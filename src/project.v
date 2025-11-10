/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_project (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Define a 128 byte memory array
  reg [7:0] memory [0:15];

  // Memory signals
  wire [3:0] mem_addr;
  wire [7:0] mem_wdata;
  reg  [7:0] mem_rdata;
  wire       mem_wr;

  // Map input signals to memory signals
  assign mem_addr  = ui_in[3:0];
  assign mem_wr    = ui_in[7];
  assign mem_wdata = uio_in;

  // Map memory signals to output signals
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ui_in[6:4], ena, 1'b0};

  // Memory process
  always @(posedge clk) begin
    if (!rst_n) begin
      mem_rdata <= 0;
    end else begin
      if (mem_wr) begin
          memory[mem_addr] <= mem_wdata;
      end
      mem_rdata <= memory[mem_addr];
    end
  end

  assign uo_out = mem_rdata;

endmodule
