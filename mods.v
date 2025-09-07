/*
 Modules in this unit
 
 // code converters
 //////////////////
 bin7seg( [3:0]di, [7:0]seg )
 bindseg( [3:0]di, [7:0]segh,[7:0]segl )
 bin2bcd( [3:0]di, [7:0]o )
 // multiplexers
 ///////////////
 mux8( i0...i7,s0,s1,s2, o )
 mux8b( [7:0]i,[2:0]s, o )
 mux2x4b( [3:0]a,[3:0]b,s, [3:0]o )
 // counter
 //////////
 cb4cled_v( clk,ce,l,up,[3:0]d,clr, [3:0]q,tc,ceo )
  */


// Code converter: bin -> 7segment, draws hexa characters

module bin7seg
  (
   input wire [3:0]  di,
   output wire [7:0] seg
   );
   
   localparam	     A      = 8'b0000_0001;
   localparam	     B      = 8'b0000_0010;
   localparam	     C      = 8'b0000_0100;
   localparam	     D      = 8'b0000_1000;
   localparam	     E      = 8'b0001_0000;
   localparam	     F      = 8'b0010_0000;
   localparam	     G      = 8'b0100_0000;
   
   assign seg = (
		 (di == 4'h0) ? A|B|C|D|E|F :
		 (di == 4'h1) ? B|C :
		 (di == 4'h2) ? A|B|G|E|D :
		 (di == 4'h3) ? A|B|C|D|G :
		 
		 (di == 4'h4) ? F|B|G|C :
		 (di == 4'h5) ? A|F|G|C|D : 
		 (di == 4'h6) ? A|F|G|C|D|E :
		 (di == 4'h7) ? A|B|C :
		 
		 (di == 4'h8) ? A|B|C|D|E|F|G :
		 (di == 4'h9) ? A|B|C|D|F|G :
		 (di == 4'ha) ? A|F|B|G|E|C :
		 (di == 4'hb) ? F|G|C|D|E :
		 
		 (di == 4'hc) ? G|E|D :
		 (di == 4'hd) ? B|C|G|E|D :
		 (di == 4'he) ? A|F|G|E|D :
		 (di == 4'hf) ? A|F|G|E :
		 8'b0000_0000
		 );
   
endmodule // bin7seg


// Code converter: bin -> 2 digits decimal display on 7seg

module bindseg
(
  input wire [3:0] di,
  output wire [7:0] segh,
  output wire [7:0] segl
);

   wire [7:0] bcd;
   wire [7:0] sh;
   
   bin2bcd u1( .di(di), .o(bcd) );
   bin7seg u2( .di(bcd[7:4]), .seg(sh) );
   bin7seg u3( .di(bcd[3:0]), .seg(segl) );
   
   assign segh= (di>9)?sh:0;
   
endmodule // bindseg


// Code converter: bin 4 bit  ->  bcd 8 bit

module bin2bcd
(
  input wire [3:0] di,
  output reg [7:0] o
);

always @(di)
  case (di)
    4'b0000: o= 8'b0000_0000;
    4'b0001: o= 8'b0000_0001;
    4'b0010: o= 8'b0000_0010;
    4'b0011: o= 8'b0000_0011;
    4'b0100: o= 8'b0000_0100;
    4'b0101: o= 8'b0000_0101;
    4'b0110: o= 8'b0000_0110;
    4'b0111: o= 8'b0000_0111;
    4'b1000: o= 8'b0000_1000;
    4'b1001: o= 8'b0000_1001;
    4'b1010: o= 8'b0001_0000;
    4'b1011: o= 8'b0001_0001;
    4'b1100: o= 8'b0001_0010;
    4'b1101: o= 8'b0001_0011;
    4'b1110: o= 8'b0001_0100;
    4'b1111: o= 8'b0001_0101;
  endcase
  
endmodule // bin2bcd


// 8 input multiplexer

module mux8(
    input i0,
    input i1,
    input i2,
    input i3,
    input i4,
    input i5,
    input i6,
    input i7,
    input s0,
    input s1,
    input s2,
    output reg o
    );
    
always @(i0,i1,i2,i3,i4,i5,i6,i7,s0,s1,s2)
  case ({s2,s1,s0})
    3'd0: o=i0;
    3'd1: o=i1;
    3'd2: o=i2;
    3'd3: o=i3;
    3'd4: o=i4;
    3'd5: o=i5;
    3'd6: o=i6;
    3'd7: o=i7;    
  endcase
  
endmodule // mux8


// 8 input multiplexer with bus inputs

module mux8b(
  input wire [7:0] i,
  input wire [2:0] s,
  output wire o
);

  mux8 mux8i(
    .i0(i[0]),
    .i1(i[1]),
    .i2(i[2]),
    .i3(i[3]),
    .i4(i[4]),
    .i5(i[5]),
    .i6(i[6]),
    .i7(i[7]),
    .s0(s[0]),
    .s1(s[1]),
    .s2(s[2]),
    .o(o)
  );
      
endmodule // mux8b


// 2 input multiplexer, 4 item packed in one module

module mux2x4b
  (
   input wire [3:0] a,
   input wire [3:0] b,
   input wire s,
   output reg [3:0] o
   );
   
   always @(a,b,s)
     case (s)
       1'b0: o= a;
       1'b1: o= b;
     endcase // case (s)
   
endmodule // mux2x4b


// 4 bit loadable cascadable bidirectional binary counter with
// clock enable and asynchronous clear

module cb4cled_v
  (
   input wire	     clk, // clock
   input wire	     ce,  // clock enable
   input wire	     l,   // load
   input wire	     up,  // direction: up
   input wire [3:0]  d,   // parallel data input
   input wire	     clr, // async clear
   output wire [3:0] q,   // counter value
   output wire	     tc,  // terminal count
   output wire	     ceo  // cascade clock enable
   );

   reg [3:0]   r= 0;
   wire        en;
   
   assign en= ce | l;
   
   always @(posedge clk, posedge clr)
     begin
	if (clr)
	  r<= 0;
	else if (en)
	  begin
	     if (l)
	       r<= d;
	     else if (up)
	       r<= r+1;
	     else
	       r<= r-1;
	  end
     end

   assign q= r;

   wire tc_up, tc_down;

   assign tc_up= &r;
   assign tc_down= ~|r;
   assign tc= up?tc_up:tc_down;
   assign ceo= ce & tc;
   
endmodule // cb4cled_v
