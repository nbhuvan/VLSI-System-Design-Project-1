// Testbanch module for the backend. This is has a module instantiation for
// the FPGA_model and the backend.
`timescale 1ns / 1ps
//==========================================================================
//Change the Verilog filenames approppriately.
`include "FPGA_model.v"
`include "backend.v"
//=========================================================================

module backend_tb();

reg resetbFPGA;
reg main_clk;

wire [1:0]gainA1 ; 
wire [2:0]gainA2 ;
wire resetbAll, resetb1, resetb2, resetbvco; 
reg vco_clk;
wire sclk, sdin;
wire ready;

initial begin
	$monitor("%t %b %b %b %b %b %b",$time,ready, resetb1, resetb2, gainA1, gainA2, resetbvco);
end

//==========================================================================
//FPGA model instantiation
FPGA_model   FPGA_obj(	.i_resetbFPGA (resetbFPGA),
			.i_ready (ready),
			.o_resetbAll (resetbAll),
			.i_mainclk (main_clk),
			.o_sclk (sclk), 
			.o_sdout (sdin));

// Backend instantiation 
backend backend_obj (	.i_resetbAll (resetbAll),
			.i_clk (main_clk),
			.i_sclk (sclk),
			.i_sdin (sdin),
			.i_vco_clk (vco_clk),
			.o_ready (ready),
			.o_resetb1 (resetb1),
			.o_gainA1 (gainA1),
			.o_resetb2 (resetb2),
			.o_gainA2 (gainA2),
			.o_resetbvco (resetbvco)
			);
//============================================================================
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0,backend_tb);
    end

//Test signal generation
initial
begin
	resetbFPGA <= 0;
	main_clk <= 0;
	vco_clk <= 0;
	#1 resetbFPGA <= 1;
	// #10000 $finish;
end

//Generation of main_clk 
always #2.5 main_clk <= ~main_clk;
always #0.555 vco_clk <= ~vco_clk;
//============================================================================
endmodule
