`timescale 1 ns/10 ps

`include "rc.model.f.v"

module rc_assert(input rst, input clk, input[7:0] v_in, output [7:0] v_out);

  rc_model osc(.v_in(v_in), .v_out(v_out), .clk(clk), .rst(rst));

  /* always begin
    assert(v_out == 0);
  end */


  always @(posedge clk) begin
    if (ticks == 0) begin
      rst <= 1;
      ticks <= 0;
    end else begin
      rst <= 0;
      ticks <= ticks + 1;
    end

    if (ticks > 100) begin
      assert(1);
      // assert(0);
      // assert(v_out == 0);
    end
  end

endmodule
