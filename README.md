# VLSI-System-Design

## Project : Design of Backend for mixed-signal IC


The chip consists of two amplifiers and an oscillator. The backend has to ensure that these analog modules are initialized correctly and the chip is ready for use. The designed backend executes a start-up sequence to ensure all are initialized correctly. 

The chip will be interfaced with an external controller (FPGA) to control the start-up sequence.

This backend is also equipped with a frequency estimator to estimate clock frequency of an unknown clock. Estimator has a precision of 0.001 MHz. 