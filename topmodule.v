module Top_module( clk, rst, sns1, sns2, Tcount, Pcount, Wtime, Full_F, Empty_F );
//input declaration
input clk, rst, sns1, sns2;
input [1:0]Tcount;

//outputs declaration
output Full_F, Empty_F;
parameter n = 3;
output [n-1:0]Pcount;
output [n+1:0]Wtime;

//wires declaration
wire inc, dec;

wire empty, full;
wire [n+1:0]time1;

//sensor 1 & 2 , Counter instanciation
photocell_fsm pc1( clk, rst, sns1, inc);
photocell_fsm pc2( clk, rst, sns2, dec);
nbit_counter cntr( clk, rst, inc, dec, Pcount);


//flag setter instanciation
flag_setter FS( clk, rst, Pcount, empty, full);
assign Empty_F = empty; 
assign Full_F = full; 

//ROM instanciation

ROM rom1( clk, Tcount, Pcount, time1 );
assign Wtime = time1;
assign Wtime = time1; 


//warning message block
always@(*)
begin
if( Full_F ) $display("Line is full & No one can enter the queue");
if( Empty_F ) $display("Line is Empty & No one can leave the queue");
end

endmodule




//Overall Test bench
module Top_module_tb;
parameter n=3;
reg clk,rst,sns1,sns2;
reg[1:0]Tcount;
wire Full_F,Empty_F;
wire[n-1:0]Pcount;
wire[n+1:0]Wtime; // wtiem is n+1 to 0 

//Top_module instanciation
Top_module TM(clk,rst,sns1,sns2,Tcount,Pcount,Wtime,Full_F,Empty_F);

initial begin
clk<=0;
rst<=1;
sns1<=1;
sns2<=1;
Tcount<=1;
end

always begin
#5 clk<=~clk;
end




initial begin
#20 //giving enough time for reset.
rst<=0;

//testing end sensor only //incrementing sesnsor, sensor 1 and overflow warnings

repeat(28)@(posedge clk)begin
#20
sns1= ~sns1 ;
end
#30
//testing front sensor only //decrementing sesnsor, sensor 2, and overflow warnings
repeat(20)@(posedge clk)begin
#20
sns2= ~sns2 ;
end
#30
//testing both sensors simultaneously
repeat(30)@(posedge clk)begin
sns1<=1;
sns2<=1;
#10
sns1<=0;
#10
sns2<=0;
#20 

sns1<=1;
sns2<=1;
end





end






endmodule
