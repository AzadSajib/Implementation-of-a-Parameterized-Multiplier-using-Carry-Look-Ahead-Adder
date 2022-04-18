module CLA_Multiplier_tb();
  parameter n = 32;
  parameter m= 32;
  parameter delay= 5;

  reg [n-1:0] multicand; 
  reg [m-1:0] multiplier; 

  wire [(n+m-1):0] product;

 CLA_Multiplier MUL1(
   .product (product[(n+m-1):0]),
   .multicand (multicand[n-1:0]),
   .multiplier (multiplier[m-1:0])
 );

 initial 
   begin
     multicand = 16'd0;
     multiplier = 8'd0;
   end 
  
  integer i;
  
  initial 
    begin
      
      for (i = 0; i < 50; i = i + 1)   
        begin: W
          #(delay) 
          multicand = multicand + 1; 
          multiplier = multiplier + 1; 
        end
 
  #(delay) //correct
  multicand = 32'd10;
  multiplier = 32'd12;
 
  #(delay) //correct
  multicand = 32'd1234;
  multiplier = 32'd10;
 
  #(delay) //faila
  multicand = 32'h00008FF0;
  multiplier = 32'h000000F0;
 
  #(delay) //correct
  multicand = 32'h00007FF0;
  multiplier = 32'h000000F7;
 
  #(delay) //correct
  multicand = 32'h0000FFFF;
  multiplier = 32'h000000FF;
 end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
endmodule
