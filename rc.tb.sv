`timescale 1 ns/10 ps

`include "rc.model.f.v"

module rc_tb;

  reg [7:0] v_in;
  reg [7:0] v_out;
  reg clk;
  reg rst;

  localparam period = 1;
  localparam delay = 128*period;

  rc_model osc(.v_in(v_in), .v_out(v_out), .clk(clk), .rst(rst));

  always begin
    clk = 1;
    #period;
    clk = 0;
    #period;
  end

  initial begin
    $dumpfile("rc.vcd");
    $dumpvars(0, rc_tb);
    clk = 0;
    rst = 0;
    v_in = 0;

    rst = 1;
    #period;
    rst = 0;
`define VAL 64

    #delay
    assert(v_out == 0);
    v_in = `VAL;
    #delay
    v_in = 0;
    #delay
    v_in = `VAL/2;
    #delay
    v_in = `VAL;
    #delay
    v_in = `VAL/2;
    #delay
    v_in = 0;
    #delay

    $display("done");
    $finish;
  end
endmodule
