`include "serial_data.v"

module testbench();

    reg i_resetbAll;
    reg i_clk;
    reg i_sclk;
    reg i_sdin;
    reg i_vco_clk;

    wire o_ready;
    wire o_resetb1;
    wire [1:0] o_gainA1;
    wire o_resetb2;
    wire [2:0] o_gainA2;
    wire o_resetbvco;
    


    initial begin
        $monitor("%t %b %b %b %b %b %b ",$time,o_ready, o_resetb1, o_resetb2, o_gainA1, o_gainA2, o_resetbvco);
        // $monitor("%t iclk: %b; i_sclk: %b; i_sdin: %b; %b %b",$time,i_clk,i_sclk,i_sdin,o_gainA1,o_gainA2);
    end

    initial begin
        $dumpfile("backend.vcd");
        $dumpvars(0,testbench);
    end
        
    backend bk(i_resetbAll,
                i_clk,
                i_sclk,
                i_sdin,
                i_vco_clk,
                o_ready,
                o_resetb1,
                o_gainA1,
                o_resetb2,
                o_gainA2,
                o_resetbvco);

    initial begin
        i_clk = 0;
        i_resetbAll = 1;
        i_sclk = 0;
        i_sdin = 0;
        i_vco_clk = 0; 
        #5 i_resetbAll = 0;
        #15 i_resetbAll = 1;
        // $display("%t",$time);
        #20 i_sdin = 1;
        #30 i_sdin = 0;
        #30 i_sdin = 0;
        #30 i_sdin = 1;
        #30 i_sdin = 1;
        #30 i_sdin = 0;
        #700 $finish;   
    end 
    always #15 i_sclk = ~i_sclk;
    always #10 i_clk = ~i_clk; 
    
    



endmodule



module backend (
    i_resetbAll,
    i_clk,
    i_sclk,
    i_sdin,
    i_vco_clk,
    o_ready,
    o_resetb1,
    o_gainA1,
    o_resetb2,
    o_gainA2,
    o_resetbvco
);
    input i_resetbAll;
    input i_clk;
    input i_sclk;
    input i_sdin;
    input i_vco_clk;

    output reg o_ready;
    output reg o_resetb1;
    output reg [1:0] o_gainA1;
    output reg o_resetb2;
    output reg [2:0] o_gainA2;
    output reg o_resetbvco;
    
//    wire [4:0] data;
    // initial begin
    //     data = 5'd0;
    // end
    integer  i;

    always @(negedge(i_resetbAll)) begin
        o_ready = 0;
        o_resetb1 = 0;
        o_gainA1 = 2'd0;
        o_resetb2 = 0;
        o_gainA2 = 3'd0;
        o_resetbvco = 0;
        // data = 5'd0;
    end
    // serialData sd(i_sclk,i_sdin,o_gainA1);
    always @(posedge(i_resetbAll)) begin
        
        @(posedge(i_sclk));
        @(posedge(i_sclk));
        o_gainA1[0] = i_sdin;

        @(posedge(i_sclk));
        o_gainA1[1] = i_sdin;
        // repeat(2)begin
        //     @(posedge(i_sclk));
        //     o_gainA1[i] = i_sdin;
        // end

        for(i=0;i<3;i=i+1)begin
            @(posedge(i_sclk));
            o_gainA2[i] = i_sdin;
        end
        // // o_gainA1 = data[1-:2];
        // // o_gainA2 = data[4-:3];
        // $display("%t",$time);
        // for(i=0;i<2;i++)begin
        //     @(posedge(i_clk));
        //     @(posedge(i_clk));
        // end
        
        // $display("%t",$time);
        // $display("%t",$time);
        repeat(2)begin
            @(posedge(i_clk));
        end
        o_resetbvco = 1;

        repeat(10)begin
            @(posedge(i_clk));
        end
        o_resetb1 = 1;
        o_resetb2 = 1;
        repeat(10)begin
            @(posedge(i_clk));
        end
        o_ready = 1;
    end


endmodule