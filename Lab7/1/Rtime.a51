; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp START

org 200h
START:
      mov P2,#00h
      mov P1,#00h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay_LCD
	;clr p1.0
	  acall delay_LCD
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	
	  acall delay_LCD
	  acall delay_LCD
	  acall delay_LCD

LJMP RESET				//stay here 

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_LCD
         clr   LCD_en
	     acall delay_LCD

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_LCD
         clr   LCD_en
         
		 acall delay_LCD
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_LCD
         clr   LCD_en
         
		 acall delay_LCD

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_LCD
         clr   LCD_en

		 acall delay_LCD
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_LCD
         clr   LCD_en
		 acall delay_LCD
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay_LCD
         clr   LCD_en
         acall delay_LCD
		 acall delay_LCD
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay_LCD:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop3:	 djnz r1, loop3
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "Toggle SW1", 00H
my_string2:
         DB   "if LED glows", 00H
my_string3:
         DB   "Reaction Time", 00H
my_string4:
         DB   " milliseconds", 00H
my_string5:
		 DB   "Count is ", 00H
			 
Reset:
	
	  mov a,#83h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD

	  mov a,#0C2H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string2   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD
	
	  MOV R0, #02H
	  ACALL DELAY2
	  SETB P1.0
	  SETB P1.4
	  MOV R4,  #00H
	  MOV TH0, #00H
	  MOV TL0, #00H
	  REACTIONTIME:
	  SETB TR0
	  CHECK1: JNB TF0, CHECK1
	  INC R4
	  JB P1.0, STAGE2
	  JMP REACTIONTIME
	  
	  STAGE2:
	  
	  mov a,#81h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD
	  
	  
	  mov a,#0C0H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD
	  
	  MOV A, R4
	  ACALL ASCII 
	  MOV A, #0C9H
	  ACALL lcd_command
	  ACALL delay_LCD
	  MOV A, 60H
	  ACALL lcd_senddata
	  MOV A,#0CAH
	  ACALL delay_LCD
	  ACALL lcd_command
	  ACALL delay_LCD
	  MOV A, 62H
	  ACALL lcd_senddata
	  acall delay_LCD
	  
	  MOV A, TH0
	  ACALL ASCII
	  
	  MOV A, #0CBH
	  ACALL lcd_command
	  ACALL delay_LCD
	  MOV A, 60H
	  ACALL lcd_senddata
	  ACALL delay_LCD
	  mov a, #0cch
	  acall lcd_command
	  acall delay_LCD
	  mov a, 62h
	  acall lcd_senddata
	  acall delay_LCD
	  
	  MOV A, Tl0
	  ACALL ASCII
	  
	  MOV A, #0CDH
	  ACALL lcd_command
	  ACALL delay_LCD
	  MOV A, 60H
	  ACALL lcd_senddata
	  ACALL delay_LCD
	  mov a, #0CEh
	  acall lcd_command
	  acall delay_LCD
	  mov a, 62h
	  acall lcd_senddata
	  acall delay_LCD
	  
	  mov r0, #05h
	  acall delay2
	  
	  
      ljmp true_end
	  
	
DELAY2:	
	LCALL CLK
	DJNZ R0, DELAY2 
	RET
	
CLK:
	MOV R1,#28H
CYCLE1:	
    CLR TF0
    DJNZ R1, TIMER
	RET
	
TIMER:	

    MOV TMOD, #01H
	MOV TH0, #36H
	MOV TL0, #00H
    SETB TR0

CYCLE2: JNB TF0, CYCLE2
    JMP CYCLE1
	
	
ASCII:  
       MOV B,#10H
       DIV AB
       CJNE A,#0AH,L1    ; compare the number with A
	   ACALL LABEL2
	   MOV 60H,A
	   MOV A,B
	   CJNE A,#0AH,L2
	   JMP L2
	  
	    
L1: ACALL CHECK
    MOV 60H,A
    MOV A,B
	CJNE A,#0AH,L2
	JMP LABEL2
	
L2:
	ACALL CHECK
	MOV 62H,A
	RET
	
CHECK: JNC LABEL2
       JC  LABEL1
	   
LABEL1:ADD A,#30H          ; If the number is lesser than A add with 30H
       RET
	   
LABEL2:ADD A,#37H          ;If the number is greater than A add with 37H
       RET
STOP:
       RET
	
true_end:
end	