 
class ram_scoreboard; 
   ram_transaction ref2sb_trans, mon2sb_trans; 
   mailbox #(ram_transaction) mbx_rs; 
   mailbox #(ram_transaction) mbx_ms; 
  
   logic [7:0] ref_mem [31:0];  
   logic [7:0] mon_mem [31:0];  
   static int MATCH = 0; 
   static int MISMATCH = 0; 
  
  // Methods
  function new(mailbox #(ram_transaction) mbx_rs, 
               mailbox #(ram_transaction) mbx_ms); 
    this.mbx_rs=mbx_rs; 
    this.mbx_ms=mbx_ms; 
  endfunction  
  
  task start(); 
    for(int i=0;i<`num_transactions;i++) begin 
        ref2sb_trans=new(); 
        mon2sb_trans=new(); 
      
        fork  
        begin  
           mbx_rs.get(ref2sb_trans); 
          ref_mem[ref2sb_trans.address]=ref2sb_trans.data_out; 
          $display("---------SCOREBOARD REF data_out=%0h, ADDRESS=%0h -------------", ref_mem[ref2sb_trans.address], ref2sb_trans.address, $time); 
        end 
        begin 
           mbx_ms.get(mon2sb_trans); 
          mon_mem[mon2sb_trans.address]=mon2sb_trans.data_out; 
          $display("+++++++++SCOREBOARD MON data_out=%0h,  ADDRESS=%0h +++++++++++", mon_mem[mon2sb_trans.address], mon2sb_trans.address, $time); 
        end 
        join 
        if (i != (`num_transactions-1)) 
            compare_report(); 
     end 
  endtask
                    
  task compare_report(); 
    if(ref_mem[ref2sb_trans.address] === mon_mem[mon2sb_trans.address]) begin 
    	$display("SCOREBOARD REF data_out=%0h, MON data_out=%0h", ref_mem[ref2sb_trans.address], mon_mem[mon2sb_trans.address], $time); 
        MATCH++; 
        $display("DATA MATCH SUCCESSFUL. MATCH count = %0d",MATCH); 
     end 
     else begin 
        $display("SCOREBOARD REF data_out=%0h, MON data_out=%0h", ref_mem[ref2sb_trans.address], mon_mem[mon2sb_trans.address], $time); 
        MISMATCH++; 
        $display("DATA MATCH FAILURE. MISMATCH count = %0d",MISMATCH); 
     end 
     $display("total count:%0d",(MATCH + MISMATCH));
endtask 
endclass                   
