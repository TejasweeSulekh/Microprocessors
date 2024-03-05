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
         DB   "Level 1", 00H
my_string2:
         DB   "Level 2", 00H
my_string3:
         DB   "Level 3", 00H
my_string4:
         DB   "Level 4", 00H
my_string5:
		 DB   "Value: ", 00H
	
RESET:	
MOV 70H, #0f3H
MOV 71H, #0b1H
MOV A, 70H
SWAP A
MOV 70H, A
MOV P1, 70H
      
	  mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD

	  mov a,#0C2H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD
      
	  MOV A, 70H
	  ACALL ASCII
	  
	  MOV A,#0C9H
	  ACALL lcd_command
	  MOV A,79H
	  ACALl lcd_senddata
	  MOV A,#0CAH
	  ACALL lcd_command
	  MOV A,77H
	  ACALL lcd_senddata
	  MOV A,#0CBH
	  ACALL lcd_command
	  MOV A,75H
	  ACALL lcd_senddata
	  MOV A,#0CCH
	  ACALL lcd_command
	  MOV A,73H
	  ACALL lcd_senddata
	  
	  ACALL DELAY
MOV A, 70H
SWAP A
MOV 70H, A
MOV P1, 70H

	mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string2   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD

	  mov a,#0C2H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD
      
	  MOV A, 70H
	  ACALL ASCII
	  
	  MOV A,#0C9H
	  ACALL lcd_command
	  MOV A,79H
	  ACALl lcd_senddata
	  MOV A,#0CAH
	  ACALL lcd_command
	  MOV A,77H
	  ACALL lcd_senddata
	  MOV A,#0CBH
	  ACALL lcd_command
	  MOV A,75H
	  ACALL lcd_senddata
	  MOV A,#0CCH
	  ACALL lcd_command
	  MOV A,73H
	  ACALL lcd_senddata

ACALL DELAY

MOV A, 71H
SWAP A
MOV 71H, A
MOV P1, 71H

	mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD

	  mov a,#0C2H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD
      
	  MOV A, 71H
	  ACALL ASCII
	  
	  MOV A,#0C9H
	  ACALL lcd_command
	  MOV A,79H
	  ACALl lcd_senddata
	  MOV A,#0CAH
	  ACALL lcd_command
	  MOV A,77H
	  ACALL lcd_senddata
	  MOV A,#0CBH
	  ACALL lcd_command
	  MOV A,75H
	  ACALL lcd_senddata
	  MOV A,#0CCH
	  ACALL lcd_command
	  MOV A,73H
	  ACALL lcd_senddata

ACALL DELAY 

MOV A, 71H
SWAP A
MOV 71H, A
MOV P1, 71H

	mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string4   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD

	  mov a,#0C2H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD
      
	  MOV A, 71H
	  ACALL ASCII
	  
	  MOV A,#0C9H
	  ACALL lcd_command
	  MOV A,79H
	  ACALl lcd_senddata
	  MOV A,#0CAH
	  ACALL lcd_command
	  MOV A,77H
	  ACALL lcd_senddata
	  MOV A,#0CBH
	  ACALL lcd_command
	  MOV A,75H
	  ACALL lcd_senddata
	  MOV A,#0CCH
	  ACALL lcd_command
	  MOV A,73H
	  ACALL lcd_senddata

ACALL DELAY

LJMP TRUE_END

DELAY:	
	MOV R1,#28H
LOOP1:	
    CLR TF0
    DJNZ R1, TIMER
	RET
	
TIMER:	

    MOV TMOD, #01H
	MOV TH0, #36H
	MOV TL0, #00H
    SETB TR0

LOOP: JNB TF0, LOOP
    JMP LOOP1	
	
ASCII:  
      MOV B, #10H
	  DIV AB
	  MOV B,#02H
	  DIV AB
	  MOV 80H, A
	  MOV A, B
	  ADD A, #30H
	  MOV 73H, A
	  MOV A, 80H
	  MOV B,#02H
	  DIV AB
	  MOV 80H, A
	  MOV A, B
	  ADD A,#30H
	  MOV 75H, A
	  MOV A, 80H
	  MOV B,#02H
	  DIV AB
	  MOV 80H, A
	  MOV A, B
	  ADD A,#30H
	  MOV 77H, A
	  MOV B,#02H
	  MOV A, 80H
	  DIV AB
	  MOV 80H, A
	  MOV A, B
	  ADD A, #30H
	  MOV 79H, A
	  RET

TRUE_END:
END