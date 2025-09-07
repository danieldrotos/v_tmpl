module test_mod();

   wire clk;
   sim_clock gen_clk(.clk(clk));

   // Variables
   wire v3, v2, v1, v0;
   wire [3:0] vb;
   
   // Generate all combinations of input variables
   sim_bin   gen_bin (.b3(v3), .b2(v2), .b1(v1), .b0(v0));
   //sim_bbin  geb_bbin(.b(vb));

   // Other input generators:
   //////////////////////////
   //sim_binv      gen_binv     (.v3(v3), .v2(v2), .v1(v1), .v0(v0));
   //sim_bbinv     geb_bbin     (.v(vb));
   //sim_bcd       gen_bcd      (.b3(v3), .b2(v2), .b1(v1), .b0(v0));
   //sim_bcdv      gen_bcdv     (.v3(v3), .v2(v2), .v1(v1), .v0(v0));
   //sim_bbcd      gen_bcdb     (.b(vb));
   //sim_bbcdv     gen_bbcdv    (.v(vb));
   //sim_gray      gen_gray     (.g3(v3), .g2(v2), .g1(v1), .g0(v0));
   //sim_grayv     gen_grayv    (.v3(v3), .v2(v2), .v1(v1), .v0(v0));
   //sim_bgray     gen_bgray    (.g(vb));
   //sim_bgrayv    gen_bgrayv   (.v(vb));
   //sim_aiken     gen_aiken    (.a3(v3), .a2(v2), .a1(v1), .a0(v0));
   //sim_aikenv    gen_aikenv   (.v3(v3), .v2(v2), .v1(v1), .v0(v0));
   //sim_baiken    gen_baiken   (.a(vb));
   //sim_baikenv   gen_baikenv  (.v(vb));
   //sim_baikenv   gen_baikenv  (.v(vb));
   //sim_stibitz   gen_stibitz  (.s3(v3), .s2(v2), .s1(v1), .s0(v0));
   //sim_stibitzv  gen_stibitzv (.v3(v3), .v2(v2), .v1(v1), .v0(v0));
   //sim_bstibitz  gen_bstibitz (.s(vb));
   //sim_bstibitzv gen_bstibitzv(.v(vb));
   
   /******************************************************/
   // You can use a display unit to draw your output functions:
   // sim_7seg(a,b,c,d,e,f,g,dp)       -- draws one digit 7seg display
   // sim_b7seg(d)                     -- draws one digit 7seg display (bus input)
   // sim_display(d0,d1,d2,d3)         -- draws 4 digits of 7seg displays
   // sim_printd(b)                    -- draws 4 bit binary code
   //                                     in decimal on 2 digits 7seg display
   // sim_led(l0,l1,l2,l3,l4,l5,l6,l7) -- draws 8 LEDS
   // sim_bled(l)                      -- draws 8 LEDS (bus input)
   // sim_print_state(clk,q)           -- prints sequntial state values
   // Output drawings can be found in Tcl Console window

   // Place your tested system here


   
   /******************************************************/
   // Save simulation result to a file for examine it later
   // Stop simulation after some steps
   initial
     begin
	$dumpfile("test_mod.vcd");
	$dumpvars();

	#35 // adjust simulation steps for your needs
	  $finish(); 
     end
   
endmodule // test_mod


/*******************************************************************************/

// Clock generator for simulation
// Generates 16 clock pulses after Xilinx global reset

module sim_clock
  (
   output wire clk
   );

   parameter STEPS= 16;

   reg 	       c= 0;

   always #1 c<=!c;

   assign clk= c;

   //initial #(100+2*STEPS) $finish();
   
endmodule // sim_clock


/*******************************************************************************/

// Print sequential circuit state

module sim_print_state
  (
   input wire clk,
   input wire [3:0] q
   );

   always @(posedge clk)
     begin
	if (q==0)
	  $write("\n0");
	else
	  $write(" %d", q);
     end
   
endmodule // sim_prints


/*******************************************************************************/

// 7seg displayer for simulation

module sim_b7seg
  (
   input wire [7:0] d
 );
 
 sim_7seg dsp(.a(d[0]),
	      .b(d[1]),
	      .c(d[2]),
	      .d(d[3]),
	      .e(d[4]),
	      .f(d[5]),
	      .g(d[6]),
	      .dp(d[7]));
 
endmodule // sim_b7seg

module sim_7seg
  (
   input wire a,
   input wire b,
   input wire c,
   input wire d,
   input wire e,
   input wire f,
   input wire g,
   input wire dp
 );
   
   always @(a,b,c,d,e,f,g,dp)
     begin
	//$write("\033[2;1H");
	$display("Step %0d. 7seg display:",$stime/2);
	$display("%c[91m",27);
	$display("%s", a?" @@@@ ":"     ");
	$display("%s    %s", f?"@":" ", b?"@":" ");
	$display("%s    %s", f?"@":" ", b?"@":" ");
	$display("%s    %s", f?"@":" ", b?"@":" ");
	$display("%s", g?" @@@@ ":"     ");
	$display("%s    %s", e?"@":" ", c?"@":" ");
	$display("%s    %s", e?"@":" ", c?"@":" ");
	$display("%s    %s", e?"@":" ", c?"@":" ");
	$display("%s %s", d?" @@@@ ":"     ", dp?"@":" ");	
	$display("%c[0m",27);
     end
   
endmodule // sim_7seg


/*******************************************************************************/

// 4 digit 7seg display for simulation

module sim_display
  (
   input wire [7:0] d0,
   input wire [7:0] d1,
   input wire [7:0] d2,
   input wire [7:0] d3
   );

   always @(d0,d1,d2,d3)
     begin
	//$write("\033[2;1H");
	$display("Step %0d. 4x7seg display:",$stime/2);
	$display("%c[91m",27);
	$display("%s    %s    %s    %s", d3[0]?" @@@@ ":"     ", d2[0]?" @@@@ ":"     ", d1[0]?" @@@@ ":"     ", d0[0]?" @@@@ ":"     ");
	$display("%s    %s    %s    %s    %s    %s    %s    %s", d3[5]?"@":" ", d3[1]?"@":" ", d2[5]?"@":" ", d2[1]?"@":" ", d1[5]?"@":" ", d1[1]?"@":" ", d0[5]?"@":" ", d0[1]?"@":" ");
	$display("%s    %s    %s    %s    %s    %s    %s    %s", d3[5]?"@":" ", d3[1]?"@":" ", d2[5]?"@":" ", d2[1]?"@":" ", d1[5]?"@":" ", d1[1]?"@":" ", d0[5]?"@":" ", d0[1]?"@":" ");
	$display("%s    %s    %s    %s    %s    %s    %s    %s", d3[5]?"@":" ", d3[1]?"@":" ", d2[5]?"@":" ", d2[1]?"@":" ", d1[5]?"@":" ", d1[1]?"@":" ", d0[5]?"@":" ", d0[1]?"@":" ");
	$display("%s    %s    %s    %s", d3[6]?" @@@@ ":"     ", d2[6]?" @@@@ ":"     ", d1[6]?" @@@@ ":"     ", d0[6]?" @@@@ ":"     ");
	$display("%s    %s    %s    %s    %s    %s    %s    %s", d3[4]?"@":" ", d3[2]?"@":" ", d2[4]?"@":" ", d2[2]?"@":" ", d1[4]?"@":" ", d1[2]?"@":" ", d0[4]?"@":" ", d0[2]?"@":" ");
	$display("%s    %s    %s    %s    %s    %s    %s    %s", d3[4]?"@":" ", d3[2]?"@":" ", d2[4]?"@":" ", d2[2]?"@":" ", d1[4]?"@":" ", d1[2]?"@":" ", d0[4]?"@":" ", d0[2]?"@":" ");
	$display("%s    %s    %s    %s    %s    %s    %s    %s", d3[4]?"@":" ", d3[2]?"@":" ", d2[4]?"@":" ", d2[2]?"@":" ", d1[4]?"@":" ", d1[2]?"@":" ", d0[4]?"@":" ", d0[2]?"@":" ");
	//$display("%s    %s", d3[4]?"@":" ", d3[2]?"@":" ");
	//$display("%s    %s", d3[4]?"@":" ", d3[2]?"@":" ");
	//$display("%s    %s", d3[4]?"@":" ", d3[2]?"@":" ");
	$display("%s %s  %s %s  %s %s  %s %s", d3[3]?" @@@@ ":"     ", d3[7]?"@":" ", d2[3]?" @@@@ ":"     ", d2[7]?"@":" ", d1[3]?" @@@@ ":"     ", d1[7]?"@":" ", d0[3]?" @@@@ ":"     ", d0[7]?"@":" ");	
	$display("%c[0m",27);
     end
   
endmodule // sim_display


module sim_printd
  (
   input wire [3:0] b
   );

   wire [7:0]	    digh;
   wire [7:0]	    digl;

   bindseg decoder( .di(b), .segh(digh), .segl(digl) );
   sim_display display( .d3(8'b0), .d2(8'b0), .d1(digh), .d0(digl) );
   
endmodule // sim_print_decimal


/*******************************************************************************/

// Displays 8 LEDS

module sim_bled
  (
   input wire [7:0] l
   );

   sim_led leds(.l0(l[0]),
		.l1(l[1]),
		.l2(l[2]),
		.l3(l[3]),
		.l4(l[4]),
		.l5(l[5]),
		.l6(l[6]),
		.l7(l[7]));
	     
endmodule // sim_bled

module sim_led
  (
   input wire l0,
   input wire l1,
   input wire l2,
   input wire l3,
   input wire l4,
   input wire l5,
   input wire l6,
   input wire l7
   );

   always @(l0,l1,l2,l3,l4,l5,l6,l7)
     begin
	$write("Step %0d. ", $stime/2);
	$display("LED:%c[92m %c %c %c %c %c %c %c %c %c[0m",27,
		 l7?"@":".",
		 l6?"@":".",
		 l5?"@":".",
		 l4?"@":".",
		 l3?"@":".",
		 l2?"@":".",
		 l1?"@":".",
		 l0?"@":".",
		 27);
     end
   
endmodule // sim_led


/*******************************************************************************/

// Signal generator for 4 bit binary code

module sim_bbin
  (
   output wire [3:0] b
   );

   sim_bin bins(.b0(b[0]),
		.b1(b[1]),
		.b2(b[2]),
		.b3(b[3]));
		
endmodule // sim_bbin

module sim_bbinv(output wire [3:0] v);
   sim_bbin binv(.b(v));
endmodule // sim_bbinv
  
module sim_bin
  (
   output reg b0,
   output reg b1,
   output reg b2,
   output reg b3
   );
   
   always #2
     if ({b3,b2,b1,b0}!=4'b1111)
       {b3,b2,b1,b0}={b3,b2,b1,b0}+1;
     else
       {b3,b2,b1,b0}={4'b1111};
   
   initial
     {b3,b2,b1,b0}=0;
   
endmodule // sim_bin

module sim_binv
  (
   output wire v0,
   output wire v1,
   output wire v2,
   output wire v3
   );
   sim_bin binv(.b0(v0),.b1(v1),.b2(v2),.b3(v3));
endmodule // sim_binv

   
/*******************************************************************************/

// Signal generator for 4 bit bcd code

module sim_bbcd
  (
   output wire [3:0] b
   );

   sim_bcd bcds(.b0(b[0]),
		.b1(b[1]),
		.b2(b[2]),
		.b3(b[3]));
		
endmodule // sim_bbcd

module sim_bbcdv(output wire [3:0] v);
   sim_bbcd bcdv(.b(v));
endmodule // sim_bbcdv

module sim_bcd
  (
   output reg b0,
   output reg b1,
   output reg b2,
   output reg b3
   );

   always #2
     if ({b3,b2,b1,b0}!=4'b1001)
       {b3,b2,b1,b0}={b3,b2,b1,b0}+1;
     else
       {b3,b2,b1,b0}={4'b1001};
   
   initial
     {b3,b2,b1,b0}=0;

endmodule // sim_bcd

module sim_bcdv
  (
   output wire v0,
   output wire v1,
   output wire v2,
   output wire v3
   );
   sim_bcd bcdv(.b0(v0),.b1(v1),.b2(v2),.b3(v3));
endmodule // sim_binv

/*******************************************************************************/

// Signal generator for 4 bit gray code

module sim_bgray
  (
   output wire [3:0] g
   );

   sim_gray grays(.g0(g[0]),
		  .g1(g[1]),
		  .g2(g[2]),
		  .g3(g[3]));
		  
endmodule // sim_bgray

module sim_bgrayv(output wire [3:0] v);
   sim_bgray bcdv(.g(v));
endmodule // sim_bgrayv

module sim_gray
  (
   output reg g0,
   output reg g1,
   output reg g2,
   output reg g3
   );
   
   always #2
     case ({g3,g2,g1,g0})
       4'b0000: {g3,g2,g1,g0}=4'b0001;
       4'b0001: {g3,g2,g1,g0}=4'b0011;
       4'b0011: {g3,g2,g1,g0}=4'b0010;
       4'b0010: {g3,g2,g1,g0}=4'b0110;
       4'b0110: {g3,g2,g1,g0}=4'b0111;
       4'b0111: {g3,g2,g1,g0}=4'b0101;
       4'b0101: {g3,g2,g1,g0}=4'b0100;
       4'b0100: {g3,g2,g1,g0}=4'b1100;
       4'b1100: {g3,g2,g1,g0}=4'b1101;
       4'b1101: {g3,g2,g1,g0}=4'b1111;
       4'b1111: {g3,g2,g1,g0}=4'b1110;
       4'b1110: {g3,g2,g1,g0}=4'b1010;
       4'b1010: {g3,g2,g1,g0}=4'b1011;
       4'b1011: {g3,g2,g1,g0}=4'b1001;
       4'b1001: {g3,g2,g1,g0}=4'b1000;
       4'b1000: {g3,g2,g1,g0}=4'b1000;
     endcase
   
   initial
     {g3,g2,g1,g0}=0;
   
endmodule // sim_gray

module sim_grayv
  (
   output wire v0,
   output wire v1,
   output wire v2,
   output wire v3
   );
   sim_gray grayv(.g0(v0),.g1(v1),.g2(v2),.g3(v3));
endmodule // sim_grayv

/*******************************************************************************/

// Signal generator for 4 bit aiken code

module sim_baiken
  (
   output wire [3:0] a
   );

   sim_aiken aikens(.a0(a[0]),
		    .a1(a[1]),
		    .a2(a[2]),
		    .a3(a[3]));
		   
endmodule // sim_baiken

module sim_baikenv
  (
   output wire [3:0] v
   );

   sim_aiken aikens(.a0(v[0]),
		    .a1(v[1]),
		    .a2(v[2]),
		    .a3(v[3]));
		   
endmodule // sim_baikenv

module sim_aiken
  (
   output reg a0,
   output reg a1,
   output reg a2,
   output reg a3
   );
   
   always #2
     if ({a3,a2,a1,a0}<4'b0100)
       {a3,a2,a1,a0}={a3,a2,a1,a0}+1;
     else if ({a3,a2,a1,a0}==4'b0100)
       {a3,a2,a1,a0}=4'b1011;
     else if ({a3,a2,a1,a0}!=4'b1111)
       {a3,a2,a1,a0}={a3,a2,a1,a0}+1;
     else
       {a3,a2,a1,a0}=4'b1111;
   
   initial
     {a3,a2,a1,a0}=0;
   
endmodule // sim_aiken

module sim_aikenv
  (
   output wire v0,
   output wire v1,
   output wire v2,
   output wire v3
   );
   sim_aiken aikenv(.a0(v0),.a1(v1),.a2(v2),.a3(v3));
endmodule // sim_aikenv

/*******************************************************************************/

// Signal generator for 4 bit stibitz code

module sim_bstibitz
  (
   output wire [3:0] s
   );

   sim_stibitz stibits(.s0(s[0]),
		       .s1(s[1]),
		       .s2(s[2]),
		       .s3(s[3]));
		       
endmodule // sim_bstibitz

module sim_stibitz
  (
   output reg s0,
   output reg s1,
   output reg s2,
   output reg s3
   );
   
   always #2
     case ({s3,s2,s1,s0})
       4'b0011: {s3,s2,s1,s0}=4'b0100;
       4'b0100: {s3,s2,s1,s0}=4'b0101;
       4'b0101: {s3,s2,s1,s0}=4'b0110;
       4'b0110: {s3,s2,s1,s0}=4'b0111;
       4'b0111: {s3,s2,s1,s0}=4'b1000;
       4'b1000: {s3,s2,s1,s0}=4'b1001;
       4'b1001: {s3,s2,s1,s0}=4'b1010;
       4'b1010: {s3,s2,s1,s0}=4'b1011;
       4'b1011: {s3,s2,s1,s0}=4'b1100;
       4'b1100: {s3,s2,s1,s0}=4'b1100;
     endcase
   
   initial
     {s3,s2,s1,s0}=4'b0011;
   
endmodule // sim_stibitz
