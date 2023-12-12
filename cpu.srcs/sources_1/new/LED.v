`timescale 1ns / 1ps

module LED( input led_clk,    		    // ʱ���ź�
            input ledrst, 		        // ��λ�ź�
            input LEDCtrlLow,		      // ��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź�   
            input LEDCtrlHigh,		      // ��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź�   
            input[15:0] ledwdata,	  //  д��LEDģ������ݣ�ע��������ֻ��16��
            output reg [23:0] ledout	//  ������������24λLED�ź�
            );

    
   always@(posedge led_clk or posedge ledrst) begin
        if(ledrst) begin
            ledout <= 24'h000000;
        end
		else if(LEDCtrlLow == 1'b1)begin
				ledout[23:0] <= { ledout[23:16], ledwdata[15:0] };
		end
		else if(LEDCtrlHigh ==1'b1 )begin
				ledout[23:0] <= { ledwdata[7:0], ledout[15:0] };
		end
        else begin
            ledout <= ledout;
        end
    end
endmodule
