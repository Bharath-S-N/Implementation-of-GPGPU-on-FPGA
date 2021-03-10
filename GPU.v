
module GPU
 #(			 parameter HWIDTH=17,  //9 + 8 bits =17 bits
			 parameter VWIDTH=200,   // depth of 200 (not bits) for reg "out"
             parameter Vertical_Width=8) //8 bits = 256 values
(           
input rst,
input clk,
input [HWIDTH-1:0] X1,X2, //Inputs in the x-axis
input [Vertical_Width-1:0] Y1,Y2, //Inputs in the y-axis
output [8:0] short  //Just for the horizontal line at each iteration
//output [HWIDTH-1:0] long[VWIDTH-1:0]  //Short=Short edge; Long=long edge
);
reg [HWIDTH-1:0] mx,x,temp; //Slope, x variable, to count the edge side
reg horizontal;
reg [8:0] out [VWIDTH-1:0], out1 [VWIDTH-1:0] ;//320x200 resolution
reg [Vertical_Width-1:0] count;
integer i,j;
//  reg clk100;
initial begin        
      count = 'b0;
      x = 'b0;           
      mx = 17'bx;
      horizontal ='bx;
      j=0;
      for(i = 0; i < 8'd200 ; i = i + 1)
      begin
          out [i] <=  'b0;  
      end
        
end

/*always@(posedge(clk))
begin
  repeat(100)
  begin
    clk100 <= clk100 ? 1'b0 :1'b1 ;
  end
  
end
*/
always@(posedge(clk))
begin
  if(~rst)
  begin
    count = 'b0;  
    for(i = 0; i < 8'd200 ; i = i + 1)
       begin
         out [i] <=  'b0;  
       end
  end
  else
    begin
      temp = x;
      if(~horizontal)
        begin
                     
            if((count<=Y2)&&(count>=Y1))
                begin     
                    out[count] = temp>>8;
                    temp += mx;
                    count++;   
                end 
            if((count == Y2)||(count == 'd200))
               begin
                 count = 'b0;
               end             
        end
      else
       begin
         count = 'b0;         
         if((temp <= X2) && (temp >= X1))
          begin
           out[Y1] = temp>>8;
           temp++;
          end              
            
       end
    end
end

always@(*)
    begin 
          if(~rst)
          begin
              x = 'b0;           
              mx = 17'bx;
              horizontal ='bx;
          end         
          mx = (X2-X1) << 8;
          if(Y2 == Y1)
            horizontal = 1'b1;
          else begin
            mx /= (Y2-Y1);
            horizontal = 1'b0;
          end           
          x = X1<<8;        
    end
assign short = out[count];
endmodule