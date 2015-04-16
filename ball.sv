//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, input [7:0] keycode,
               output [9:0]  BallX, BallY, BallS, motion1);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
logic check;
    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	
	assign motion1 [7:0] = keycode[7:0];
	//assign motion2 = Ball_X_Motion;
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				
        end
           
        else 
        begin 
				//if(keycode == 2'h26 || keycode == 2'h04 || keycode == 2'h22 || keycode == 2'h07)
				//begin	
				/*case(keycode)
					//W = 0x26, A=0x04, S=0x22, D=0x07
					8'h1a : begin
						Ball_X_Motion <= 10'd0;
						Ball_Y_Motion <= 10'b1111111100;
					end
					8'h04 : begin
						Ball_Y_Motion <=10'd0;
						Ball_X_Motion <= 10'b1111111100;
					end
					8'h16 : begin
						Ball_X_Motion <= 10'd0;
						Ball_Y_Motion <= 10'd4;
					end
					8'h07 : begin
						Ball_Y_Motion <= 10'd0;
						Ball_X_Motion <= 10'd4;
					end
					default : begin
					Ball_X_Motion<=Ball_X_Motion;
					Ball_Y_Motion<=Ball_Y_Motion;
					end
				endcase
				*/
				 //if(keycode == 8'h1a ||keycode == 8'h04||keycode==8'h16||keycode==8'h07)
				 
				 // check boundaries, if not on boundary, check keycodes
				 
				 //begin
					 /*if(keycode == 8'h1a)
					 begin
						Ball_X_Motion <= 10'd0;
						Ball_Y_Motion <= 10'b1111111111;//10'b1111111100;
					 end
					 else if(keycode == 8'h04)
					 begin
						Ball_Y_Motion <=10'd0;
						Ball_X_Motion <= 10'b1111111111; //10'b1111111100;
					 end
					 else if(keycode==8'h16)
					 begin
						Ball_X_Motion <= 10'd0;
						Ball_Y_Motion <= 10'd1; //10'd4;
					 end
					 else if(keycode==8'h07)
					 begin
						Ball_Y_Motion <= 10'd0;
						Ball_X_Motion <= 10'd1; //10'd4;
					 end
					 */
				//end
				//old bounce code
				 //check <= 0;
				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  //Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  begin
					  Ball_Y_Motion <= 10'b1111111111;
					  Ball_X_Motion <= 10'd0;
					//  check <= 1'b1;
					  end
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  //Ball_Y_Motion <= Ball_Y_Step;
					  begin
					  Ball_Y_Motion <= 10'b0000000001;
					  Ball_X_Motion <= 10'd0;
					  //check <= 1'b1;
					  end
				 else if ((Ball_X_Pos + Ball_Size) >= Ball_X_Max) //Ball is at right edge, BOUNCE!
					  //Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
					  begin
					  Ball_X_Motion <= 10'b1111111111;
					  Ball_Y_Motion <= 10'd0;
					  //check <= 1'b1;
					  end
				 else if((Ball_X_Pos - Ball_Size) <= Ball_X_Min) //Ball is at left edge, BOUNCE!
					  //Ball_X_Motion <= Ball_X_Step;
					  begin
					  Ball_X_Motion <= 10'b0000000001;
					  Ball_Y_Motion <= 10'd0;
					  //check <= 1'b1;
					  end
				 else 	  
					if( keycode == 8'h1a)// && check == 1'b0)// && (Ball_Y_Pos - Ball_Size > Ball_Y_Min) ) //problem with w
						begin
							Ball_X_Motion <= 10'd0;
							Ball_Y_Motion <= 10'b1111111111;//10'b1111111100;
						end
					else if(keycode == 8'h04)// && check==1'b0)// && (Ball_X_Pos - Ball_Size > Ball_X_Min)) // problem with a
						begin
							Ball_Y_Motion <=10'd0;
							Ball_X_Motion <= 10'b1111111111; //10'b1111111100;
						end
					else if(keycode==8'h16)// && check == 1'b0)
						begin
							Ball_X_Motion <= 10'd0;
							Ball_Y_Motion <= 10'd1; //10'd4;
						end
					else if(keycode==8'h07)// && check == 1'b0)
						begin
							Ball_Y_Motion <= 10'd0;
							Ball_X_Motion <= 10'd1; //10'd4;
						end	
					else
						begin
							Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
							Ball_X_Motion <= Ball_X_Motion;
						end		
				 //Ball_X_Motion <= Ball_X_Motion;  // You need to remove this and make both X and Y respond to keyboard input
				 
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule
