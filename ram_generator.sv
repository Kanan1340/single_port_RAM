
class ram_generator;
  
ram_transaction blueprint;
mailbox #(ram_transaction)mbx_gd;

	function new(mailbox #(ram_transaction)mbx_gd);
		this.mbx_gd = mbx_gd;
 		blueprint=new();
	endfunction
  
	task start(); 
    	  for(int i=0; i<`num_transactions; i++) begin 
	     assert(blueprint.randomize());  
	     mbx_gd.put(blueprint.copy());   
             $display("GENERATOR Randomized transaction data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", blueprint.data_in, blueprint.write_enb, blueprint.read_enb, blueprint.address, $time); 
      	end 
  	endtask
  
endclass
  
  
