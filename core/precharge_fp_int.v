

module precharge_fp_int
(
  input sys_clk,
  input clk,
  input reset,
  input [11-1:0] VREF,
  input [12-1:0] VREG,
  output [20-1:0] out
);

  reg [20-1:0] o;
  wire [20-1:0] const_0;
  assign const_0 = 865075;
  assign out = o;

  always @(posedge clk) begin
    if(reset) begin
      o <= 865075;
    end else begin
      o <= const_0;
    end
  end


endmodule

