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
    
    integer  i;
    reg k;
    initial k = 0; // State for frequency estimation
    

    // ################################################################################

    // Reset Registers

    always @(negedge(i_resetbAll)) begin
        o_ready = 0;
        o_resetb1 = 0;
        o_gainA1 = 2'd0;
        o_resetb2 = 0;
        o_gainA2 = 3'd0;
        o_resetbvco = 0;
        k = 0;
    end


    // ################################################################################

    // Serial Data communication 
    
    always @(posedge(i_resetbAll)) begin
        
        for(i=0;i<2;i=i+1)begin // Runs for two positive edges of i_sclk and reads the serial data into o_gainA1
            @(posedge(i_sclk));
            o_gainA1[i] = i_sdin;
        end


        for(i=0;i<3;i=i+1)begin // Runs for three positive edges of i_sclk and reads the serial data into o_gainA2
            @(posedge(i_sclk));
            o_gainA2[i] = i_sdin;
        end

        repeat(2)begin         // Waits for two clock cycles and then sets o_resetbvco
            @(posedge(i_clk));
        end
        o_resetbvco = 1;

        repeat(10)begin         // Waits for ten clock cycles and then sets o_resetb1 and o_resetb2
            @(posedge(i_clk));
        end
        o_resetb1 = 1;
        o_resetb2 = 1;

        repeat(10)begin         // Waits for ten clock cycles and then sets o_ready
            @(posedge(i_clk));
        end
        o_ready = 1;
    end

    // ################################################################################

    // Frequency Estimator

    real mainf = 0;
    real vcof = 0;
    real vco_freq = 0;

    always @(posedge(i_resetbAll)) begin
        k = 1;
    end

    always @(posedge(i_clk) && k) begin
        mainf = mainf + 1;
        if(mainf==10000)begin
            @(posedge(i_vco_clk));
            vco_freq = (vcof*200)/mainf;
            $display("\n i_vco_frequency: %0.3f MHz\n",vco_freq);
            k = 0;
            mainf = 0;
            vcof = 0;
            $finish; // Finishes after estimating the frequency;
        end
    end

    always @(posedge(i_vco_clk) && k) begin
        vcof = vcof + 1;
    end


    // ################################################################################

endmodule