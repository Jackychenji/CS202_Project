`timescale 1ns / 1ps
module decode32(    
                output[31:0] read_data_1,             // 在ifetch要用，jr指令用的地址         
                output[31:0] read_data_2,              
                input[31:0]  Instruction,            
                input[31:0]  mem_data,                  
                input[31:0]  ALU_result,                 
                input        Jal,                     // 为1表明是Jal指令, 为0时表示不是Jal指令
                input        RegWrite,                // 为1表明该指令需要写寄存器 
                input        MemtoReg,                // 为1表明需要从存储器或I/O读数据到寄存器
                input        RegDst,             
                output[31:0] Sign_extend,              
                input         clock,reset,            //时钟与复位,复位信号用于给PC赋初始值，复位信号高电平有效     
                input[31:0]  opcplus4                 
     );

     
     reg[31:0] register[0:31]; 
     wire[5:0] opcode; 
     wire[4:0] rs;
     wire[4:0] rt;
     reg[4:0] write_adr;
     reg[31:0] write_data;
     wire[4:0] rd;
     wire[15:0] immediate_value;
     wire sign;
     reg[31:0] imme_extend;
     assign opcode = Instruction[31:26];
     assign rs = Instruction[25:21];
     assign rt = Instruction[20:16];
     assign rd = Instruction[15:11];
     assign immediate_value = Instruction[15:0];
     assign Sign_extend = imme_extend;
     assign read_data_1 = register[rs];
     assign read_data_2 = register[rt];
     always@* begin
         if(opcode==6'b001101||opcode==6'b001100||opcode==6'b001110||opcode==6'b001011)begin
             imme_extend={{16{1'b0}},immediate_value};
         end
         else begin
             imme_extend={{16{Instruction[15]}},immediate_value};
         end
     end//judge if need sign extension
     
     always@* begin
         if(MemtoReg==1'b0&&Jal==1'b0) begin
             write_data = ALU_result;
         end
         else if(Jal==1'b1)begin
             write_data =opcplus4 ;
         end
         else begin
             write_data = mem_data;
         end
     end//judge the type
     
     always@* begin
         if(RegWrite==1'b1)begin
             if(opcode==6'b000011)begin
                 if(Jal==1'b1)begin
                     write_adr = 5'b11111;//jal
                 end
             end
             else if(RegDst==1'b1)begin
                 write_adr = rd;
             end
             else begin
                 write_adr = rt;
             end
         end
     end
 
 always@(posedge clock) begin
     if(reset==1'b1) begin
     register[0]<=32'd0;
     register[1]<=32'd0;
     register[2]<=32'd0;
     register[3]<=32'd0;
     register[4]<=32'd0;
     register[5]<=32'd0;
     register[6]<=32'd0;
     register[7]<=32'd0;
     register[8]<=32'd0;
     register[9]<=32'd0;
     register[10]<=32'd0;
     register[11]<=32'd0;
     register[12]<=32'd0;
     register[13]<=32'd0;
     register[14]<=32'd0;
     register[15]<=32'd0;
     register[16]<=32'd0;
     register[17]<=32'd0;
     register[18]<=32'd0;
     register[19]<=32'd0;
     register[20]<=32'd0;
     register[21]<=32'd0;
     register[22]<=32'd0;
     register[23]<=32'd0;
     register[24]<=32'd0;
     register[25]<=32'd0;
     register[26]<=32'd0;
     register[27]<=32'd0;
     register[28]<=32'd0;
     register[29]<=32'd0;
     register[30]<=32'd0;
     register[31]<=32'd0;
     end
     else if(RegWrite==1'b1)begin
         if(write_adr!=5'd0)begin
             register[write_adr]<=write_data;
         end
     end
 end
 
 endmodule
