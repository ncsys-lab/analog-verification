`timescale 1 ns/10 ps

`include "vco.model.f.v"

module vco_tb;

  reg [7:0] v_in;
  reg [7:0] v_out;
  reg clk;
  reg rst;

  localparam period = 1;
  localparam delay = (2**17)*period;

  vco_model osc(.v_in(v_in), .v_out(v_out), .clk(clk), .rst(rst));

  always begin
    clk = 1;
    #period;
    clk = 0;
    #period;
  end

  initial begin
    $dumpfile("vco.vcd");
    $dumpvars(0, vco_tb);
    clk = 0;
    rst = 0;
    v_in = 0;

    rst = 0;
    #period;
    #period;
    rst = 1;
    #period;
    #period;
    rst = 0;
`define VAL 64

    #delay
    #delay
    #delay
    #delay
    #delay
    #delay
    #delay

    $display("done");
    $finish;
  end
endmodule
