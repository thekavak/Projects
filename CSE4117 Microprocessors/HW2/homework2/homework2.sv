module homework2
  (input logic        i_clk,
   input logic [3:0]  i_keypad4x4_col_data,
	input logic i_state,
	input logic push_button_one,
	input logic push_button_two,
   output logic [3:0] o_keypad4x4_row_data,
   output logic [3:0] o_grounds,
   output logic [6:0] o_display);

   logic [15:0] keypad4x4_data;
   logic [15:0] data;
   logic        rselect;
   logic        ack;
	logic [15:0] realdata;
	logic [31:0] buffer;
	logic [31:0] buffer_2;
	logic push_button_one_state;
	logic push_button_two_state;

	//Hamza kavak
	//Resul akçakaya
	//Ozan Yerli

   sevensegment sevensegment_0
     (.clk(i_clk),
      .din(realdata),
      .grounds(o_grounds),
      .display(o_display));

   ctrl_keypad4x4 ctrl_keypad4x4_0
     (.i_clk(i_clk),
      .i_ack(ack),
      .i_rselect(rselect),
      .i_col_data(i_keypad4x4_col_data),
      .o_row_data(o_keypad4x4_row_data),
      .o_data(keypad4x4_data));
  
  
 

/*  
		realdata <= {realdata[3:0],realdata[7:4],realdata[11:8],realdata[15:12]};
	*/
	
	 
	 
   always_ff @(posedge i_clk)
     begin	 
		buffer <= {buffer[30:0],push_button_one};
		buffer_2 <= {buffer_2[30:0],push_button_two};
		
		//case changing order
		 case (push_button_one_state)
            1'b0:
                begin
                    if(&(buffer)== 1) 
                        begin
                          //  realdata <= {realdata[3:0],realdata[7:4],realdata[11:8],realdata[15:12]};
								  realdata <= {realdata[11:0],realdata[15:12]};
                            push_button_one_state<=1;
                        end
                end
            1'b1:
                begin
                   if(|(buffer) == 0) 
                        push_button_one_state<=0;
                end
        endcase
		  
		  //case +1 
		   case (push_button_two_state)
            1'b0:
                begin
                    if(&(buffer_2)== 1) 
                        begin
                            realdata<=realdata + 1;
                            push_button_two_state<=1;
                        end
                end
            1'b1:
                begin
                   if(|(buffer_2) == 0) 
                        push_button_two_state<=0;
                end
        endcase
		  
		  
	  
        if ((keypad4x4_data[0] == 1'b1) && (rselect == 1)) begin
           ack <= 1;
           rselect <= 0;
        end else if (rselect == 0) begin
           data <= keypad4x4_data;
					if(i_state==1)
					begin
						realdata<={realdata[11:0],keypad4x4_data[3:0]};
					end
					else
					begin
						realdata<={keypad4x4_data[3:0],realdata[15:4]};

					end
					
           ack <= 0;
           rselect <= 1;
        end else begin
           ack <= 0;
           rselect <= 1;
        end
     end
	  


   initial
     begin
        data = 0;
		  realdata = 0;
        ack = 0;
        rselect = 1;
		  buffer = 32'b0;
     end

endmodule