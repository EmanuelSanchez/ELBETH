////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_csr_register.v
//  Created On    : Mon Feb  22 08:51:00 2016
//  Last Modified : 2016-03-07 21:03:10
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : 
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

//Definir región ilegal y arreglar illegal acces en control
//


module elbeth_csr_register(
		input                        clk,
		input                        rst,
		input [11:0]				 addr,
		input [2:0]   				 cmd,
		input [31:0]        		 wdata,
		input                        retire,
		input                        exception,
		input [3:0]     			 exception_code,
		input                        eret,
		input [31:0] 		         exception_load_addr,
		input [31:0]        		 exception_pc,
	 	output [1:0]				 prv,
		output 						 io_interrupt,
		output                       illegal_access,
		output reg [31:0]		     rdata,
		output [31:0]        		 handler_pc,
		output [31:0]       		 epc,
		output [3:0]			 	 io_interrupt_code
		);

	reg [63:0]		cycle_full;
	wire [31:0]		cycle;
	wire [31:0]		cycleh;
	reg [63:0]      time_full;
	wire [31:0]		_time;
	wire [31:0]		timeh;
	reg [63:0]      instret_full;
	wire [31:0]		instret;
	wire [31:0]		instreth;

	wire [31:0]		mcpuid;
	wire [31:0]		mimpid;
	wire [31:0]		mhartid;
	wire [31:0]		mstatus;
	reg [31:0]		mtvec;
	wire [31:0]		mtdeleg;
	wire [31:0]		mie;
	reg [31:0]		mtimecmp;

	reg [63:0]		mtime_full;
	wire [31:0]		mtime;
	wire [31:0]		mtimeh;

	reg [31:0]		mscratch;
	reg [31:0]		mepc;
	wire [31:0]		mcause;
	reg [31:0]		mbadaddr;
	wire [31:0]		mip;

	reg [31:0]		from_host;
	reg [31:0] 		to_host;
	//Registers auxiliares
	reg [5:0] 		priv_stack;
	wire 			ie;

	reg 			defined;
	reg [31:0]		wdata_internal;
	wire 			wen_internal;
	wire 			mtimer_expired;
	reg 			msip;
	reg 			mtip;
	reg 			mtie;
	reg 			msie;
	reg 			mecode;
	reg 			mint;
	reg 			interrupt_taken;
	wire 			system_en;
	wire 			system_wen;
	wire [3:0]		code_imem;
	wire 			illegal_region;
	wire 			minterrupt;
	wire 			uinterrupt;
	reg  [3:0] 		interrupt_code;

	//Some asignmaments
	assign cycle = cycle_full[31:0];
	assign cycleh = cycle_full[63:32];
	assign _time = time_full[31:0];
	assign timeh = time_full[63:32];
	assign instret = instret_full[31:0];
	assign instreth = instret_full[63:32];
	assign mtime = mtime_full[31:0];
	assign mtimeh = mtime_full[63:32];

	assign mstatus = {26'h0, priv_stack};		//SD = 0, VM = 0000, MPRV = 0, FX = 0, XS = 0 (View the Machine Level Section)
	assign mtdeleg = 32'b0;						//Trap are processed by Machine mode
	
	assign mip = {mtip, 3'h0, msip, 3'h0};
	assign mie = {mtie, 3'h0, msie, 3'h0};
 
	assign ie = priv_stack[0];
	assign mtimer_expired = (mtimecmp == mtime);
	assign system_en = cmd[2];
	assign system_wen = cmd[1] | cmd[0];
	assign mcause = {mint, 27'b0, mecode};
	assign code_imem = ((exception_code ==`ECODE_INST_ADDR_MISALIGNED) | (exception_code == `ECODE_INST_ADDR_FAULT)); // `ECODE_INST_ADDR_FAULT no aparece en vscale
	assign illegal_region = ((system_wen & (addr[12-1:10] == 3)) | (system_en & (addr[10-1:8] > prv)));	

	//Outpus
	assign prv = priv_stack[2:1];
	assign io_interrupt = mint;
	assign io_interrupt_code = mecode;
	assign handler_pc = (mtvec + (prv << 6));  /// << 5 en vscale
	assign illegal_access = (illegal_region || (system_en && (!defined)));
	assign epc = mepc;
	assign wen_internal = system_wen;
	assign uinterrupt = 0;
	assign minterrupt = (mtie & mtimer_expired);
	assign mcpuid = ((1 << 20) | (1 << 8));
	assign mimpid = 32'h8000;
	assign mhartid = 0;



	// The priviledge mode stack.
	// 
	// - At reset: machine mode.
	// - Exception: shift stack to the left, enter machine mode.
	// - Eret: shift stack to the right. Set next mode to User leve.

	always @(posedge clk) begin
		if (rst) begin
	        priv_stack <= 6'b000110;	//PRV0 = 11 (Machin mode) IE = 0 (Desable interrupts)
	    end
	    else if ((wen_internal & (addr == `CSR_ADDR_MSTATUS))) begin
	        priv_stack <= wdata_internal[5:0];
	    end
	    else if (exception) begin
	        priv_stack <= {priv_stack[2:0], 2'h3, 1'b0};
	    end
	    else if (eret) begin
	        priv_stack <= {2'h0, 1'b1, priv_stack[5:3]};
	    end
	end

	// Select the write data according to the command
	always @(wdata, system_wen, rdata, cmd) begin
	    if (system_wen) begin
	        case (cmd)
	            `CSR_SET: begin 	wdata_internal = (rdata | wdata); end
	            `CSR_CLEAR: begin 	wdata_internal = (rdata & (~wdata)); end
	            default: begin 		wdata_internal = wdata; end
	        endcase
	    end
	    else begin
	        wdata_internal = 32'h0BADF00D;
	    end
	end

	// Handle the flags for interrupt pending.
	always @(posedge clk) begin
	 	if (rst) begin
	    	mtip <= 0;
	    	msip <= 0;
	    end else begin
	    	if (mtimer_expired)
	    		mtip <= 1;
	    	if (wen_internal && addr == `CSR_ADDR_MTIMECMP)
	    		mtip <= 0;
	    	if (wen_internal && addr == `CSR_ADDR_MIP) begin
	     		mtip <= wdata_internal[7];
	        	msip <= wdata_internal[3];
	     	end
	  	end // else: !if(rst)
	end // always @ (posedge clk)

	// Set the interrupt code and flag.
	always @(prv, minterrupt, ie, uinterrupt) begin
	    interrupt_code = 3'b1;
	    case (prv)
	        `PRV_U : begin 		interrupt_taken = ((ie & uinterrupt) | minterrupt); end
	        `PRV_M :  begin 	interrupt_taken = (ie & minterrupt); end
	        default: begin 		interrupt_taken = 1; end
	    endcase
	end

	// Handle the interrupt enable flags.
	always @(posedge clk) begin
		if (rst) begin
	    	mtie <= 0;
	    	msie <= 0;
		end else if (wen_internal && addr == `CSR_ADDR_MIE) begin
	    	mtie <= wdata_internal[7];
	    	msie <= wdata_internal[3];
		end
	end // always @ (posedge clk)

	// Handle writes to the 'mecode' and 'mint' registers.
	always @(posedge clk) begin
    	if (rst) begin
        	mecode <= 0;
        	mint <= 0;
    	end else if (wen_internal && addr == `CSR_ADDR_MCAUSE) begin
        	mecode <= wdata_internal[3:0];
        	mint <= wdata_internal[31];
    	end else begin
        	if (interrupt_taken) begin
            	mecode <= interrupt_code;
            	mint <= 1'b1;
        	end else if (exception) begin
            	mecode <= exception_code;
            	mint <= 1'b0;
         	end
      	end // else: !if(reset)
	end // always @ (posedge clk)

	// Handle writes to the 'mbadaddr' address.
	always @(posedge clk) begin
	    if (exception) begin
	        mbadaddr <= (code_imem) ? exception_pc : exception_load_addr;
	    end
	    else if ((wen_internal & (addr == `CSR_ADDR_MBADADDR))) begin
	        mbadaddr <= wdata_internal;
	    end
	end

	// Handle writes to the mepc register.
   always @(posedge clk) begin
      if (exception | interrupt_taken)
        mepc <= (exception_pc & (~3));
      if (wen_internal & addr == `CSR_ADDR_MEPC)
        mepc <= (exception_pc & (~3));
   end

	// Read CSR registers.
	always @(*) begin
    	case (addr)
	        `CSR_ADDR_CYCLE     : begin 
		        	rdata = cycle;
		        	defined = 1'b1; end
	        `CSR_ADDR_TIME      : begin 
		        	rdata = _time;
		        	defined = 1'b1; end
	        `CSR_ADDR_INSTRET   : begin 
		        	rdata = instret;
		        	defined = 1'b1; end
	        `CSR_ADDR_CYCLEH    : begin 
	        		rdata = cycleh;
	        		defined = 1'b1; end
	        `CSR_ADDR_TIMEH     : begin 
	        		rdata = timeh;
	        		defined = 1'b1; end
	        `CSR_ADDR_INSTRETH  : begin 
	        		rdata = instreth;
	        		defined = 1'b1; end
	        `CSR_ADDR_MCPUID    : begin 
	        		rdata = mcpuid; 
	        		defined = 1'b1; end
	        `CSR_ADDR_MIMPID    : begin 
	        		rdata = mimpid;
	        		defined = 1'b1; end
	        `CSR_ADDR_MHARTID   : begin 
	        		rdata = mhartid;
	        		defined = 1'b1; end
	        `CSR_ADDR_MSTATUS   : begin 
	        		rdata = mstatus;
	        		defined = 1'b1; end
	        `CSR_ADDR_MTVEC     : begin 
	        		rdata = mtvec;
	        		defined = 1'b1; end
	        `CSR_ADDR_MTDELEG   : begin 
	        		rdata = mtdeleg; 
	        		defined = 1'b1; end
	        `CSR_ADDR_MIE       : begin 
	        		rdata = mie; 
	        		defined = 1'b1; end
	        `CSR_ADDR_MTIMECMP  : begin 
	        		rdata = mtimecmp; 
	        		defined = 1'b1; end
	        `CSR_ADDR_MTIME     : begin 
	        		rdata = mtime;
	        		defined = 1'b1; end
	        `CSR_ADDR_MTIMEH    : begin 
	        		rdata = mtimeh;
	        		defined = 1'b1; end
	        `CSR_ADDR_MSCRATCH  : begin 
	        		rdata = mscratch; 
	        		defined = 1'b1; end
	        `CSR_ADDR_MEPC      : begin 
	        		rdata = mepc; 
	        		defined = 1'b1; end
	        `CSR_ADDR_MCAUSE    : begin 
	        		rdata = mcause; 
	        		defined = 1'b1; end
	        `CSR_ADDR_MBADADDR  : begin 
	        		rdata = mbadaddr; 
	        		defined = 1'b1; end
	        `CSR_ADDR_MIP       : begin 
	        		rdata = mip; 
	        		defined = 1'b1; end
	        `CSR_ADDR_CYCLEW    : begin 
	        		rdata = cycle;
	        		defined = 1'b1; end
	        `CSR_ADDR_TIMEW     : begin 
	        		rdata = _time;
	        		defined = 1'b1; end
	        `CSR_ADDR_INSTRETW  : begin 
	        		rdata = instret;
	        		defined = 1'b1; end
	        `CSR_ADDR_CYCLEHW   : begin 
	        		rdata = cycleh;
	        		defined = 1'b1; end
	        `CSR_ADDR_TIMEHW    : begin 
	        		rdata = timeh;
	        		defined = 1'b1; end
	        `CSR_ADDR_INSTRETHW : begin 
	        		rdata = instreth;
	        		defined = 1'b1; end
	        //For simulation
	        `CSR_ADDR_TO_HOST : begin 
	        		rdata = to_host; 
	        		defined = 1'b1; end
	        `CSR_ADDR_FROM_HOST : begin 
	        		rdata = from_host; 
	        		defined = 1'b1; end
	        default : begin
	        		rdata = 0;
	        		defined = 1'b0; end
    	endcase // case (addr)
	end // always @ (*)

	// Handle writes to CSR registers
	always @(posedge clk) begin
		if (rst) begin
				cycle_full <= 64'b0;
				time_full <= 64'b0;
				instret_full <= 64'b0;
				mtime_full <= 64'b0;
				mtvec <= 32'd256;
				to_host <= 32'b0;
				from_host <= 32'b0;
		end else begin
				cycle_full <= cycle_full + 1;
				time_full <= time_full + 1;
				mtime_full <= mtime_full + 1;
				if (retire)
						instret_full <= instret_full + 1;
				if (wen_internal) begin
					case (addr)
							`CSR_ADDR_CYCLE     : cycle_full[31:0] <= wdata_internal;
							`CSR_ADDR_TIME      : time_full[31:0] <= wdata_internal;
							`CSR_ADDR_INSTRET   : instret_full[31:0] <= wdata_internal;
							`CSR_ADDR_CYCLEH    : cycle_full[63:32] <= wdata_internal;
							`CSR_ADDR_TIMEH     : time_full[63:32] <= wdata_internal;
							`CSR_ADDR_INSTRETH  : instret_full[63:32] <= wdata_internal;
							// mcpuid is read-only
							// mimpid is read-only
							// mhartid is read-only
							// mstatus handled separately (wdata_aux & (~3));
							`CSR_ADDR_MTVEC     : mtvec <= wdata_internal & (~3);
							// mtdeleg constant
							// mie handled separately
							`CSR_ADDR_MTIMECMP  : mtimecmp <= wdata_internal;
							`CSR_ADDR_MTIME     : mtime_full[31:0] <= wdata_internal;
							`CSR_ADDR_MTIMEH    : mtime_full[63:32] <= wdata_internal;
							`CSR_ADDR_MSCRATCH  : mscratch <= wdata_internal;
							// mepc handled separately
							// mcause handled separately
							// mbadaddr handled separately
							// mip handled separately
							`CSR_ADDR_CYCLEW    : cycle_full[31:0] <= wdata_internal;
							`CSR_ADDR_TIMEW     : time_full[31:0] <= wdata_internal;
							`CSR_ADDR_INSTRETW  : instret_full[31:0] <= wdata_internal;
							`CSR_ADDR_CYCLEHW   : cycle_full[63:32] <= wdata_internal;
							`CSR_ADDR_TIMEHW    : time_full[63:32] <= wdata_internal;
							`CSR_ADDR_INSTRETHW : instret_full[63:32] <= wdata_internal;
							`CSR_ADDR_TO_HOST   : to_host <= wdata_internal;
							`CSR_ADDR_FROM_HOST : from_host <= wdata_internal;
							default : ;
					endcase // case (addr)
				end // if (wen_internal)
		end
	end //always @(posedge clk)

endmodule // elbeth_csr_register