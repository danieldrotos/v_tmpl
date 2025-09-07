`timescale 1ns / 1ps


/*******************************
 *                             *
 * Top module for Logsys board *
 *                             *
 *******************************/

module logsys_top
  (
   input wire	      CLK, // 100 MHz board clock
   input wire [3:0]   BTN, // Input: Pushbuttons
   input wire [7:0]   SW , // Input: Switches
   output wire [7:0]  LED, // Output: LED (green)
   output wire [7:0]  LEDR, // Output: LED (red)
   output wire [7:0]  LEDB, // Output: LED (blue)
   output wire [3:0]  AN , // Output: 7segment display
   output wire [7:0]  SEG
   );

   // alternate name for input clock
   wire		      clk= CLK;
   
   // Generated clocks, ready to use
   wire		      clk_1MHz, clk_1KHz, clk_1Hz;
   
   // Debounced inputs, can be used as variables
   wire [7:0]	      sw;
   wire [3:0]	      btn;

   // Output values for 7segment display,
   // drive these variables by your logical functions
   wire [7:0]	      d3, d2, d1, d0;

   
   // Clock devider to produce low frequ clocks
   div clk_divider
     (
      .clk(CLK),
      .clk_1MHz(clk_1MHz), .clk_1kHz(clk_1kHz), .clk_1Hz(clk_1Hz)
      );

   // Display driver, draws values of d3...d0 on display
   dsp_drv dsp
     (
      .clk(clk_1kHz),
      .d0(d0), .d1(d1), .d2(d2), .d3(d3),
      .an(AN), .seg(SEG)
      );

   // Debouncer of buttons and switches, produces usable input values: sw, btn
   debouncer debu( .clk(clk_1kHz), .sw_in(SW), .btn_in(BTN), .sw(sw), .btn(btn) );

   
   // Place of your circuit here
   // Use sw, btn as inputs
   // Use LED, d3...d0 as outputs
   // Use LEDR outputs for red LEDs, and LEDB for blue
   /////////////////////////////////////////////////////////////////////////////
   

    
endmodule // logsys_top


/*******************************************************************************/

// Clock divider to produce low frequency clocks: 1MHz, 1kHz, 1Hz
// Duty cycle is 50% on all outputs
// Needs 100 MHz board clock as input

module div
  (
   input wire  clk, // 100 MHz
   output wire clk_1MHz,
   output wire clk_1kHz,
   output wire clk_1Hz
   );

   reg [5:0]  div50= 0;
   reg [9:0]  div500= 0;
   reg [9:0]  div500_2= 0;
   reg	      ff_1MHz= 0, ff_1kHz= 0, ff_1Hz= 0;

   wire	      div50_last= div50 == 49;
   always @(posedge clk)
     if (div50_last)
       div50<= 0;
     else
       div50<= div50+1;
    
   always @(posedge clk)
     if (div50_last)
       ff_1MHz<= !ff_1MHz;
   
   wire	      div500_last= div500 == 999;
   always @(posedge clk)
     if (div50_last)
       begin
	  if (div500_last)
            div500<= 0;
	  else
            div500<= div500+1;
       end
   
   always @(posedge clk)
     if (div50_last & div500_last)
       ff_1kHz<= !ff_1kHz;
   
   wire div500_2_last= div500_2 == 999;
   always @(posedge clk)
     if (div50_last & div500_last)
       begin
	  if (div500_2_last)
            div500_2<= 0;
	  else
            div500_2<= div500_2+1;
       end
   
   always @(posedge clk)
     if (div50_last & div500_last & div500_2_last)
       ff_1Hz<= !ff_1Hz;
   
   assign clk_1MHz= ff_1MHz;
   assign clk_1kHz= ff_1kHz;
   assign clk_1Hz = ff_1Hz;
   
endmodule // div


/*******************************************************************************/

// 1:2 frequency divider, output has 50% duty cycle

module div2
  (
   input wire  i,
   output wire o
   );

   reg	       ff= 0;
   always @(posedge i) ff<= !ff;
   assign o= ff;
   
endmodule // div2


/*******************************************************************************/

// 1:5 frequency divider, output has 3:2 duty cycle

module div5
  (
   input wire  i,
   output wire o
   );

   reg [2:0]   cnt= 0;
   always @(posedge i)
     if (cnt == 4)
       cnt<= 0;
     else
       cnt<= cnt+1;
   assign o= cnt < 3;
   
endmodule // div5


/*******************************************************************************/

// 1:10 frequency divider, output has 50% duty cycle

module div10
  (
   input wire  i,
   output wire o
   );

   reg [2:0]   cnt= 0;
   reg	       ff= 0;
   
   wire	       eq4= cnt == 4;
   always @(posedge i)
     if (eq4)
       cnt<= 0;
     else
       cnt<= cnt+1;
   
   always @(posedge i) if (eq4) ff<= !ff;
   assign o= ff;

endmodule // div10


/*******************************************************************************/

// 1:100 frequency divider, output has 50% duty cycle

module div100
  (
   input wire  i,
   output wire o
   );
   
   div10 d1(.i(i), .o(w10));
   div10 d2(.i(w10), .o(o));
   
endmodule // div100


/*******************************************************************************/

// Display driver for 8 digit 7segment display

module dsp_drv
  (
   input wire	     clk, // Recommended input clock is 1kHz
   input wire [7:0]  d0,
   input wire [7:0]  d1,
   input wire [7:0]  d2,
   input wire [7:0]  d3,
   output wire [3:0] an,
   output wire [7:0] seg
   );

   
   reg [31:0]	     data_buf;
   reg [1:0]	     cnt= 0;
   
   always @(posedge clk)
     begin
	cnt<= cnt+1;
	data_buf<= {d3, d2, d1, d0};
     end
   
   assign seg= (
		 (cnt==3'd0)?{data_buf[ 7: 0]}:
		 (cnt==3'd1)?{data_buf[15: 8]}:
		 (cnt==3'd2)?{data_buf[23:16]}:
		 (cnt==3'd3)?{data_buf[31:24]}:
		 0
		 );
   
   assign an[0]= (cnt == 0);
   assign an[1]= (cnt == 1);
   assign an[2]= (cnt == 2);
   assign an[3]= (cnt == 3);

endmodule // dsp_drv


/*******************************************************************************/

// Debounceer for 8 switches and 4 pushbuttons

module debouncer
  (
   input wire	      clk,  // 1kHz
   input wire [7:0]  sw_in,
   input wire [3:0]   btn_in,
   output wire [7:0] sw,
   output wire [3:0]  btn
   );

   reg [3:0]	      cnt= 0;
   reg [7:0]	      sw_buf;
   reg [3:0]	      btn_buf;
   
   always @(posedge clk) cnt<= cnt+1;

   // Sample rate= 1000/16= 62.5 Hz
   always @(posedge cnt[3])
     begin
	sw_buf<= sw_in;
	btn_buf<= btn_in;
     end
   
   assign sw= sw_buf;
   assign btn= btn_buf;
   
endmodule // debouncer


/*******************************************************************************/
