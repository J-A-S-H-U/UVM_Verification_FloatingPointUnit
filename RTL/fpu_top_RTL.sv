//`include "fpu_parms.sv"
`include "fpu_add_RTL.sv"
`include "fpu_mul_RTL.sv"
`include "fpu_div_RTL.sv"


module fpu_top_RTL(
        input  logic          clk,
        input  logic          reset,
	    input  logic [1:0]    cmd,
        input  logic [31:0]   din1,
        input  logic [31:0]   din2,
        input  logic          valid,
        output logic [31:0]   result,
        output logic          ready
);

parameter CMD_FPU_ADD  = 4'b0001;  
parameter CMD_FPU_MUL  = 4'b0010; 
parameter CMD_FPU_DIV  = 4'b0011; 


logic        sp_add_ready;
logic [31:0] sp_add_result;


logic        sp_mul_ready;
logic [31:0] sp_mul_result;


logic        sp_div_ready;
logic [31:0] sp_div_result;


wire sp_add_valid =  (valid) & (cmd == CMD_FPU_ADD);
wire sp_mul_valid =  (valid) & (cmd == CMD_FPU_MUL);
wire sp_div_valid =  (valid) & (cmd == CMD_FPU_DIV);



assign ready    = (cmd == CMD_FPU_ADD) ? sp_add_ready    : 
	            (cmd == CMD_FPU_MUL) ? sp_mul_ready    : 
		        (cmd == CMD_FPU_DIV) ? sp_div_ready    : 
		        '0;
assign result = (cmd == CMD_FPU_ADD) ? sp_add_result : 
	            (cmd == CMD_FPU_MUL) ? sp_mul_result : 
		        (cmd == CMD_FPU_DIV) ? sp_div_result : 
		        '0;

fpu_add_RTL  u_sp_add (
        .clk               (clk             ),
        .reset             (reset           ),
        .din1              (din1[31:0]      ),
        .din2              (din2[31:0]      ),
        .valid              (sp_add_valid     ),
        .result            (sp_add_result   ),
        .ready               (sp_add_ready      )
      );


fpu_mul_RTL  u_sp_mul (
        .clk               (clk             ),
        .reset             (reset           ),
        .din1              (din1[31:0]      ),
        .din2              (din2[31:0]      ),
        .valid              (sp_mul_valid     ),
        .result            (sp_mul_result   ),
        .ready               (sp_mul_ready      )
      );


fpu_div_RTL  u_sp_div (
        .clk               (clk             ),
        .reset             (reset           ),
        .din1              (din1[31:0]      ),
        .din2              (din2[31:0]      ),
        .valid              (sp_div_valid     ),
        .result            (sp_div_result   ),
        .ready               (sp_div_ready      )
      );

endmodule
