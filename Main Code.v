// Code your design here
// Code your design here

//***********************CLA MULTIPLIER***********************//

module CLA_Multiplier (multicand, multiplier, product);
  parameter n = 32;  // n = Multiplicand width
  parameter m = 32;	 // m = Multiplier width

  input [n-1:0] multicand;
  input [m-1:0] multiplier;
  output [(n + m - 1):0] product;

  wire [n-1:0] multicand_tmp [m-1:0];
  wire [n-1:0] product_tmp [m-1:0];
  wire [m-1:0] carry_tmp;
  
  genvar i, j;
  generate 
 //initialize values
    for(j = 0; j < m; j = j + 1) 
      begin: loop_j
        assign multicand_tmp[j] =  multicand & {n{multiplier[j]}};
      end
    
    assign product_tmp[0] = multicand_tmp[0];
    assign carry_tmp[0] = 1'b0;
    assign product[0] = product_tmp[0][0];
    
    for(i = 1; i < m; i = i + 1) 
      begin: loop_i
        CLA_Adder ADD1 (  
        //CLA_Adder #(.DATA_WID(m)) ADD1 (     
          .sum(product_tmp[i]),
          .cout(carry_tmp[i]),
          .cin(1'b0),
          .in1(multicand_tmp[i]),
          .in2({carry_tmp[i-1],product_tmp[i-1][31-:31]})
        );
        
        assign product[i] = product_tmp[i][0];
      end 
    
    assign product[(m+m-1):m] = {carry_tmp[m-1],product_tmp[m-1][31-:31]};
  endgenerate
endmodule

//***************CLA ADDER MODULE*****************// 


module CLA_Adder (in1, in2, cin, sum, cout);

	parameter n=32; // number of bits
	
	input [n-1:0] in1;
	input [n-1:0] in2;
	input cin;
	output [n-1:0] sum;
	output cout;
	
	wire [n-1:0] gen;
	wire [n-1:0] prod;
	wire [n:0] c_tmp;
	
	
	genvar i,j;
	generate 
		 assign c_tmp[0]=cin;
		 
		 for(j=0; j<n; j=j+1)
		 begin: carry_generator
			assign gen[j] = in1[j] & in2[j];
			assign prod[j] = in1[j] | in2[j];
			assign c_tmp[j+1] = gen[j] | prod[j] & c_tmp[j];
		 end 
		 
		 assign cout = c_tmp[n];
		 
		 
		 for(i=0; i<n; i=i+1)
		 begin: sum_without_carry
			assign sum[i] = in1[i] ^ in2[i] ^ c_tmp[i];
		 end 
	endgenerate
endmodule

