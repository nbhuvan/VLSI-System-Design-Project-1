`timescale 1ns / 1ps

module frequency_tb ();
    reg main_clk;
    reg vco_clk;
    wire [10:0] freq;
    reg i_resetbAll;
    initial begin
        i_resetbAll = 0;
        main_clk = 0;
        vco_clk = 0;
        #5 i_resetbAll = 1;
        // #2500 $finish;
        // #10000
    end
    initial begin
        $dumpfile("frequency_tb.vcd");
        $dumpvars(0,frequency_tb);
    end
    // initial $monitor("%d",freq);
    frequency_estimator f(main_clk,vco_clk,i_resetbAll,freq);


    always #2.5 main_clk = ~main_clk;
    always #3.425 vco_clk = ~vco_clk;

endmodule


module frequency_estimator (
    main_clk,
    vco_clk,
    i_resetbAll,
    freq
);
    input main_clk,vco_clk,i_resetbAll;
    output reg [10:0] freq;

    integer mainf = 0;
    integer vcof = 0;
    integer ans = 0;
    always @(posedge(main_clk) && i_resetbAll) begin
        mainf = mainf + 1;
        if(mainf==10000)begin
            @(posedge(vco_clk))
            vcof = vcof +1;
            $display("%d %d",mainf,vcof);
            ans = (vcof*200)/mainf;
            freq = ans;
            $display("%d",ans);
            #1000 $finish;
        end
    end

    always @(posedge(vco_clk) && i_resetbAll) begin
        vcof = vcof + 1;
    end

endmodule