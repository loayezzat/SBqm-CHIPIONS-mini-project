module nbit_counter(clk , rst , inc , dec ,count);

//generic n value
parameter n = 3;
//clock , reset , "increment & decrement signals from the sequence detector"
input clk , rst , inc , dec;
output reg[n-1:0]count;

/*
//calcuating the maximum countable number
reg [7:0]i,max; 
initial begin
max = 1;
for(i=0;i<n;i=i+1)
begin
max = max * 2 ;
end
max = max - 1 ;
end
*/

//initializing count to zero
initial count <= 0;
//resetting block
always@(posedge clk)
begin
if(rst) count <= 0;
end

//incrementation block
always@(posedge inc)
    begin
if( count == (2**n-1) ) count = count ;
else count <= count + 1;
    end

//decrementation block
always@(posedge dec)
    begin
if( count == 0 ) count = count ;
else count <= count - 1;
    end

endmodule  


//test bench module
module counter_tb;
reg clk,rst,inc,dec;
parameter n = 3;
wire [n-1:0]Pcount;

initial begin
clk <=0;
rst <=0;
end

always begin
#5
clk <= ~ clk;
end

initial begin

$monitor("%d %b %b %b %d",clk,rst,inc,dec,Pcount);
#5
inc<=1;
dec<=0;
#10
inc<=0;
dec<=1;

repeat(9)@(posedge clk)
begin
inc<=1;
dec<=0;
#2
inc<=0;
end

repeat(4)@(posedge clk)
begin
inc<=0;
dec<=1;
#2
dec<=0;
end

#10
rst <=1;
#10
rst <=0;
inc <=1;
dec <=0;

end

nbit_counter PCounter(clk , rst , inc , dec ,Pcount);

endmodule 