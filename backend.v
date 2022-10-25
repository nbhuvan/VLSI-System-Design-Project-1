// module testbench();

//     reg i_resetbAll;
//     reg i_clk;
//     reg i_sclk;
//     reg i_sdin;
//     reg i_vco_clk;

//     wire o_ready;
//     wire o_resetb1;
//     wire [1:0] o_gainA1;
//     wire o_resetb2;
//     wire [2:0] o_gainA2;
//     wire o_resetbvco;
    


//     initial begin
//         $monitor("%t %b %b %b %b %b %b ",$time,o_ready, o_resetb1, o_resetb2, o_gainA1, o_gainA2, o_resetbvco);
//     end

//     initial begin
//         $dumpfile("backend.vcd");
//         $dumpvars(0,testbench);
//     end
        
//     backend bk(i_resetbAll,
//                 i_clk,
//                 i_sclk,
//                 i_sdin,
//                 i_vco_clk,
//                 o_ready,
//                 o_resetb1,
//                 o_gainA1,
//                 o_resetb2,
//                 o_gainA2,
//                 o_resetbvco);

//     initial begin
//         i_clk = 0;
//         i_resetbAll = 1;
//         i_sclk = 0;
//         i_sdin = 0;
//         i_vco_clk = 0; 
//         #5 i_resetbAll = 0;
//         #15 i_resetbAll = 1;
//         #20 i_sdin = 1;
//         #30 i_sdin = 0;
//         #30 i_sdin = 0;
//         #30 i_sdin = 1;
//         #30 i_sdin = 1;
//         #30 i_sdin = 0;
//         #700 $finish;   
//     end 
//     always #15 i_sclk = ~i_sclk;
//     always #10 i_clk = ~i_clk; 
    
    



// endmodule


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
    reg [10:0]vco_freq;
    reg k;
    initial k = 0;
    

    // frequency_estimator fe(i_clk,i_vco_clk,i_resetbAll,vco_freq);
    initial vco_freq = 10'd0;
    // initial $monitor("%t %d",$time,vco_freq);
    always @(negedge(i_resetbAll)) begin
        o_ready = 0;
        o_resetb1 = 0;
        o_gainA1 = 2'd0;
        o_resetb2 = 0;
        o_gainA2 = 3'd0;
        o_resetbvco = 0;
        vco_freq = 10'd0;
        k = 0;
    end

    
    integer mainf = 0;
    integer vcof = 0;
    integer ans = 0;

    always @(posedge(i_resetbAll)) begin
        k = 1;
    end

    always @(posedge(i_clk) && k) begin
        mainf = mainf + 1;
        if(mainf==10000)begin
            @(posedge(i_vco_clk));
            vcof = vcof +1;
            ans = (vcof*200)/mainf;
            vco_freq = ans;
            $display("\ni_vco_frequency: %d\n",ans);
            k = 0;
            mainf = 0;
            vcof = 0;
            $finish;
        end
    end

    always @(posedge(i_vco_clk) && k) begin
        vcof = vcof + 1;
    end

    always @(posedge(i_resetbAll)) begin
        
        for(i=0;i<2;i=i+1)begin
            @(posedge(i_sclk));
            o_gainA1[i] = i_sdin;
        end


        for(i=0;i<3;i=i+1)begin
            @(posedge(i_sclk));
            o_gainA2[i] = i_sdin;
        end

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

    // always @(posedge(i_resetbAll)) begin
        
    // end



endmodule