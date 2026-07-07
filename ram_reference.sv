 
class ram_reference; 
   ram_transaction ref_trans; 
   mailbox #(ram_transaction) mbx_rs; 
   mailbox #(ram_transaction) mbx_dr; 
   virtual inf.REF_SB vif; 
   reg [7:0] MEM [31:0]; 
 
  function new(mailbox #(ram_transaction) mbx_dr, 
               mailbox #(ram_transaction) mbx_rs, 
               virtual inf.REF_SB vif); 
    this.mbx_dr=mbx_dr; 
    this.mbx_rs=mbx_rs; 
    this.vif=vif; 
  endfunction
  
  task start(); 
    for(int i=0;i<`num_transactions;i++) begin 
      ref_trans=new(); 
      mbx_dr.get(ref_trans); 
 	
	if(!vif.ref_cb.rst) begin
   	   MEM[ref_trans.address] = 'z;
   	   ref_trans.data_out = 'z;
	end

	else begin   
        if(ref_trans.write_enb)begin 
          MEM[ref_trans.address]=ref_trans.data_in; 
          $display("REFERENCE MODEL DATA IN MEMORY MEM[%0h]=%0h", ref_trans.address, MEM[ref_trans.address], $time); 
        end
	if(ref_trans.read_enb) begin 
          ref_trans.data_out=MEM[ref_trans.address]; 
          $display("REFERENCE MODEL DATA OUT FROM MEMORY data_out=%0h",ref_trans.data_out, $time); 
      	end
  	end

      mbx_rs.put(ref_trans); 
     end  
  endtask 
  
endclass
