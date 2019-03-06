module flag_setter(clk, rst, pcount, Empty_F, Full_F);
input clk,rst;
parameter n = 3;
input wire [n-1:0] pcount;
output Empty_F, Full_F;
reg rst_flag;

//resetting block
always@(posedge clk)
begin
if(rst) rst_flag <= 1 ;
else rst_flag <= 0 ;
end

//concurrent assignment for flags

assign Empty_F = (rst_flag) ? 1 : ( pcount == 0 ) ? 1 : 0;
assign Full_F = (rst_flag) ? 0 : ( pcount == (2**n-1) ) ? 1 : 0;

endmodule

module flag_tb;
parameter n = 3;
reg [n-1:0] pcount;
reg clk,rst;
wire Empty_F, Full_F;

flag_setter FS1(clk, rst, pcount, Empty_F, Full_F);

initial begin
clk <=0;
rst <=0;
end

always begin
#5
clk <= ~ clk;
end

initial begin
#5
rst <= 1;
#20
rst <= 0;
pcount <= 0;
#10
pcount <= 3;
#10
pcount <= 7;
#10
pcount <= 0;

$monitor("%d %b %d %b %b",clk, rst, pcount, Empty_F, Full_F);
end

endmodule 