`include "interface.sv" 
`include "ram_design.sv"

module top(); 
    import ram_package ::*;  
    bit clk; 
    bit rst; 
 
    initial begin 
     forever #10 clk=~clk; // Period: 20ns -> Frequency: 50Mhz 
    end 
 
  initial 
    begin 
      @(posedge clk); 
      rst=0; 
      repeat(1)@(posedge clk); 
      rst=1;
    end

//Instantiate the interface 
inf intrf(clk,rst); 
  
//Instantiate the DUV 
        RAM DUV(.data_in(intrf.data_in), 
		.write_enb(intrf.write_enb), 
		.read_enb(intrf.read_enb), 
		.data_out(intrf.data_out), 
		.address(intrf.address), 
		.clk(clk), 
		.reset(rst) 
); 
    
ram_test test ;

initial begin 
test= new(intrf.DRV, intrf.MON, intrf.REF_SB); 
end

initial begin 
	test.run(); 
	$finish(); 
end
  
endmodule 
