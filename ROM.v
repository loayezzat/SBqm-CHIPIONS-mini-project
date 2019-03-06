module ROM (clk , tcount , pcount , wtime );	 

parameter n = 3 ;

output reg [n+1:0]wtime;  
/*max value of wtime from eqn in case of 3-bits counter is 21 (can be hold in 5bit reg of max value 31)
and the size of the rom is also 5-bits
*/
input wire [n-1:0] pcount ; // n-bits vector
input wire [1:0] tcount ; // two bits vector
input wire clk ; 
wire [n+1:0] address ;  //(n+2) bits vector, n for pcount and 2 for tcount  
assign address[n+1:0] = { tcount[1:0] ,pcount[n-1:0] } ; //concatenating tcount(MSBs) and pcount(LSBs) to serve as address to the ROM
reg [n+1:0]rom [0:(2**(n+2))-1] ; // the max value of WTIME is found to be hold in (n+2) bits register no. of adresses is{ 2^(n+2) -1} 

//wtime==> waiting time 

always @(posedge clk) // refreshing the value of wtime every clk cycle according to the current values of counter and tellers.
begin
wtime <= rom[address] ;
end


integer i , p ,t ;
initial begin


for (i=0 ; i< (2**(n+2));i=i+1)
    begin  p = i&((2**n)-1);
           t=i>>n ;
         if (t == 0) rom[i]=0;
         else rom[i] = 3*(p + t -1)/(t);
    
    end
end //end of init
endmodule 



/***********************************************************************************************/
module rom_tb ();

parameter n =3 ;
 wire [4:0] wtime;  
reg[4:0]i ; 
reg [n-1:0] pcount ;
reg [1:0] tcount ;
reg clk ;
initial 
begin
i =5'b0 ;
clk =0 ;
$monitor ("%b %b  .. wtime= %d", tcount,pcount,wtime);

end

always
    begin 
#4
	 pcount<= i&3'b111;
         tcount<= i>>n ;
i<=i+1 ;
      //  if (tcount == 0) continue;
        
    end

always 
begin 
#2 clk = ~clk ;
end


ROM rm (clk , tcount , pcount ,  wtime  );	
endmodule 
