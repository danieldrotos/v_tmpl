/*
 Modules in this unit
 
 ffd( clk,d, q )
 ffde( clk,d,e, q )
 ffd_ar( clk,d,res, q )
 ffd_sr( clk,d,res, q )
 fft( clk,t, q )
 ffjk( clk,j,k, q )
  */


// D-FF

module ffd
  (
   input wire clk,
   input wire d,
   output reg q
   );

   initial q<= 0;
   
   always @(posedge clk)
     q<= d;
   
endmodule // ffd


// D-FF with enable input

module ffde
  (
   input wire clk,
   input wire d,
   input wire e,
   output reg q
   );

   initial q<= 0;
   
   always @(posedge clk)
     if (e)
       q<= d;
   
endmodule // ffd


// D-FF with async reset

module ffd_ar
  (
   input wire clk,
   input wire d,
   input wire res,
   output reg q
   );

   initial q<= 0;
   
   always @(posedge clk, posedge res)
     begin
	if (res)
	  q<= 0;
	else
	  q<= d;
     end
   
endmodule // ffd_ar


// D-FF with synch reset

module ffd_sr
  (
   input wire clk,
   input wire d,
   input wire res,
   output reg q
   );

   initial q<= 0;

   always @(posedge clk)
     begin
	if (res)
	  q<= 0;
	else
	  q<= d;
     end

endmodule // ffd_sr


// T-FF

module fft
  (
   input wire clk,
   input wire t,
   output reg q
   );

   initial q<= 0;

   always @(posedge clk)
     q<= t ^ q;
   
endmodule // fft


// JK-FF

module ffjk
  (
   input wire clk,
   input wire j,
   input wire k,
   output reg q
   );

   initial q<= 0;

   always @(posedge clk)
     q<= (j==1 && k==0)?1:
	 (j==0 && k==1)?0:
	 (j==1 && k==1)?!q:
	 q;
   
endmodule // ffjk
