`timescale 1ns / 1ps

module lab4(
  input  clk,            // System clock at 100 MHz
  input  reset_n,        // System reset signal, in negative logic
  input  [3:0] usr_btn,  // Four user pushbuttons wire
  output [3:0] usr_led   // Four yellow LEDs 
);
//0.1
reg signed [3:0] ledcounter=0; //-7~8
//2.3
reg [3:0] dutycounter=0;//count duty cycle
reg [19:0] brtcounter=0;
reg brightornot;//o off  1 on  ifon assign usr_led=ledcounter
reg [19:0] duty=1000000;
//debouncing
wire button_out_reg0, button_out_reg1,button_out_reg2,button_out_reg3;

debouncing forbut_0(.clk(clk),.din(usr_btn[0]),.dout(button_out_reg0));
debouncing forbut_1(.clk(clk),.din(usr_btn[1]),.dout(button_out_reg1));
debouncing forbut_2 (.clk(clk),.din(usr_btn[2]),.dout(button_out_reg2));
debouncing forbut_3 (.clk(clk),.din(usr_btn[3]),.dout(button_out_reg3));
      

always@(posedge clk) begin
if(brtcounter==1000000)  brtcounter=0;  //達到周期定的?值，就清零
else  brtcounter=brtcounter+1;
        
        if(reset_n==0)begin
            ledcounter=4'b0000;
            dutycounter=4'b0000;
            duty=1000000;
        end//end with if
//buttom 0&1
        if(button_out_reg0) begin
            if(ledcounter=='b1000) ledcounter ='b1000;//-8 -> -8
            else ledcounter=ledcounter-1'b1;
        end//end with if
        if(button_out_reg1) begin
              if(ledcounter=='b0111) ledcounter ='b0111;//7 -> 7
              else ledcounter=ledcounter+1'b1;
        end//end with if
//buttom 2&3
        if(button_out_reg2) begin
            if(dutycounter==0) dutycounter <= dutycounter; //0->0
            else dutycounter<=dutycounter-1;
        end//end with if
        
        if(button_out_reg3) begin
            if(dutycounter>=4) dutycounter<=4; 
            else dutycounter<=dutycounter+1;
        end//end with if
 case(dutycounter)
    'b0000: duty=50000;
    'b0001: duty=250000;
    'b0010: duty=500000;
    'b0011: duty=750000;
    'b0100: duty=1000000;
    default: duty=1000000;
 endcase
 
if(duty>=brtcounter) brightornot=1'b1;       
else brightornot=1'b0;

end//end with always begin 
assign usr_led[0]=ledcounter[0]&&brightornot;
assign usr_led[1]=ledcounter[1]&&brightornot;
assign usr_led[2]=ledcounter[2]&&brightornot;
assign usr_led[3]=ledcounter[3]&&brightornot;
endmodule

module debouncing(
 input  clk,  // System clock at 100 MHz
 input  din,
 output  dout   // Four yellow LEDs wire
);
reg [31:0] timer;
reg true;
always @(posedge clk) begin
        if(din) begin
            timer <=  timer + 24'd1;
            true = 0;
        end//end with IF begin
        
        else  begin
            timer<= 31'd0;//放開按鈕
            true = 0;
           
        end//end with ELSE begin
        
        // 當累加到 0.01 秒，LED 計數器才加一
        if(timer == 31'd10_000_000) //  10_000_000 = 0.1秒，1_000_000 = 0.01 秒
                true = 1;
               
    end//end with always begin
    
assign dout=true;   
endmodule

