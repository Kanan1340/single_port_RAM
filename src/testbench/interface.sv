`include "defines.sv"

interface inf(input bit clk,rst);
  logic[7:0] data_in,data_out; 
  logic write_enb,read_enb; 
  logic[4:0] address; 
  
  clocking drv_cb @(posedge clk); 
	default input #1 output #1; 
	output write_enb, read_enb, data_in, address; 
	input rst; 
  endclocking 
  
  clocking mon_cb @(posedge clk); 
	default input #1 output #1; 
	input data_out,address,rst; 
  endclocking 
    
  clocking ref_cb @(posedge clk); 
	default input #1 output #1;
   	input data_in,write_enb,read_enb,address,rst;
    	output data_out;
  endclocking 

modport DRV(clocking drv_cb); 
modport MON(clocking mon_cb); 
modport REF_SB(clocking ref_cb);
    
endinterface
