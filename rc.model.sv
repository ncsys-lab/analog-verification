// Model generated on 2023-04-25 16:23:11.205592

`timescale 1ns/1ps

`include "svreal.sv"
`include "msdsl.sv"

`default_nettype none

module rc_model #(
    `DECL_REAL(v_in),
    `DECL_REAL(v_out)
) (
    `INPUT_REAL(v_in),
    `OUTPUT_REAL(v_out),
    input wire logic clk,
    input wire logic rst
);
    // Assign signal: v_out
    `MUL_CONST_REAL(0.9048374180359596, v_out, tmp0);
    `MUL_CONST_REAL(0.09516258196404037, v_in, tmp1);
    `ADD_REAL(tmp0, tmp1, tmp2);
    `DFF_INTO_REAL(tmp2, v_out, rst, clk, 1'b1, 0);
endmodule

`default_nettype wire
