`timescale 1ns / 1ps
module dmemory32_Uart(
                input clock, memWrite,  //memWrite 来自controller，为1'b1时表示要对data-memory做写操作
                input [31:0] address,   //address 以字节为单位
                input [31:0] writeData, //writeData ：向data-memory中写入的数据
                output[31:0] readData,  //writeData ：从data-memory中读出的数据
                input upg_rst_i, // UPG reset (Active High)
                input upg_clk_i, // UPG ram_clk_i (10MHz)
                input upg_wen_i, // UPG write enable
                input [13:0] upg_adr_i, // UPG write address
                input [31:0] upg_dat_i, // UPG write data
                input upg_done_i // 1 if programming is finished
);
    wire ram_clk = !clock;
    
    /* CPU work on normal mode when kickOff is 1. CPU work on Uart communicate mode when kickOff is 0.*/
    wire kickOff = upg_rst_i | (~upg_rst_i &upg_done_i);
    RAM ram (
    .clka (kickOff ? ram_clk : upg_clk_i),
    .wea (kickOff ? memWrite : upg_wen_i),
    .addra (kickOff ? address[15:2] : upg_adr_i),
    .dina (kickOff ? writeData : upg_dat_i),
    .douta (readData)
    );
endmodule
