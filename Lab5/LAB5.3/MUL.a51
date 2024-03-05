; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 200h
	
start:
LCD1:
      mov P2,#00h
      mov P1,#00h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay
	  mov a,#82h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C3h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring

JMP RESET			//stay here 

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
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
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "ENTER INPUTS", 00H
my_string2:
		 DB   "EE337-2022", 00H
my_string3:
		 DB   "READING INPUTS", 00H
my_string4:
         DB   "COMPUTING RESULT", 00H
my_string5:
         DB   "NUM1:",00H
		
my_string6:
         DB   " NUM2:" ,00H
my_string7:
		 DB   " RESULT = ", 00H
my_string8:
         DB   "  ", 00H			 
RESET:
MOV P1,#0F0H
ACALL DELAY_2

STATE1:

MOV R1, #1

mov p1, #00h

SETB P1.7
SETB P1.0
SETB P1.1
SETB P1.2
SETB P1.3


	  mov a,#81h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C3H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string2   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

ACALL DELAY_2
MOV A,P1
MOV P1, #00H
MOV B,#10H
DIV AB
MOV A,B
MOV B,#10H
MUL AB
MOV 30H,A

SETB P1.6
SETB P1.0
SETB P1.1
SETB P1.2
SETB P1.3
ACALL DELAY_2
MOV A,P1
MOV P1, #00H
MOV B,#10H
DIV AB
MOV A,B
ADD A,30H
MOV 30H,A

SETB P1.5
SETB P1.0
SETB P1.1
SETB P1.2
SETB P1.3
ACALL DELAY_2
MOV A,P1
MOV P1, #00H
MOV B,#10H
DIV AB
MOV A,B
MOV B,#10H
MUL AB
MOV 31H,A

SETB P1.4
SETB P1.0
SETB P1.1
SETB P1.2
SETB P1.3
ACALL DELAY_2
MOV A,P1
MOV P1, #00H
MOV B,#10H
DIV AB
MOV A,B
ADD A,31H
MOV 31H,A
MOV P1,#00H

ACALL ASCII
      MOV 64H,60H
	  MOV 66H,62H
	  MOV A, 30H
	  
ACALL ASCII	 

	  mov a,#80H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string4   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall DELAY_2

	  mov a,#0C0H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  MOV A,#0C5H
	  ACALL lcd_command
	  MOV A,60H
	  ACALl lcd_senddata
	  MOV A,#0C6H
	  ACALL lcd_command
	  MOV A,62H
	  ACALL lcd_senddata
	  
	  mov a,#0C7H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string6   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  MOV A,#0CDH
	  ACALL lcd_command
	  MOV A,64H
	  ACALl lcd_senddata
	  MOV A,#0CEH
	  ACALL lcd_command
	  MOV A,66H
	  ACALl lcd_senddata
	  
	  acall DELAY_2

Multiplier:
    MOV A, 30H
	MOV B, 31H
	MUL AB
	MOV 50H, A
	MOV 51H, B
	MOV 6AH, 60H
	MOV 6CH, 62H
	MOV A, 51H
	ACALL ASCII
	MOV 70H, 60H
	MOV 72H, 62H
	MOV A, 50H
	ACALL ASCII
	
	MOV A,#80H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string7   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	 
    MOV A,#8AH
    ACALL lcd_command
    ACALL delay
    MOV A, 70H
    ACALL lcd_senddata
    MOV A,#8BH
    ACALL lcd_command
	ACALL delay
	MOV A, 72H
	ACALL lcd_senddata
	MOV A,#8CH
	ACALL lcd_command
	ACALL delay
	MOV A, 60H
	ACALL lcd_senddata
	MOV A,#8DH
	ACALL lcd_command
	ACALL delay
	MOV A, 62H
	ACALL lcd_senddata
	acall delay
	MOV A,#8EH		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string8   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring
	
	
	  MOV A,#0C0H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  MOV A,#0C5H
	  ACALL lcd_command
	  MOV A,6AH
	  ACALl lcd_senddata
	  MOV A,#0C6H
	  ACALL lcd_command
	  MOV A,6CH
	  ACALL lcd_senddata
	  
	  mov a,#0C7H		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string6   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  MOV A,#0CDH
	  ACALL lcd_command
	  MOV A,64H
	  ACALl lcd_senddata
	  MOV A,#0CEH
	  ACALL lcd_command
	  MOV A,66H
	  ACALl lcd_senddata
	  
	  wait: sjmp wait



ASCII:  
       MOV B,#10H
       DIV AB
       CJNE A,#0AH,L1    ; compare the number with A
	   ACALL LABEL2
	   MOV 60H,A
	   MOV A,B
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

DELAY_2:
PUSH 00H
MOV R0, #10
LOOP3: ACALL DELAY_200MS
DJNZ R0, LOOP3
POP 00H
RET

DELAY_200MS:
PUSH 00H
MOV R0, #200
LOOP: ACALL DELAY_1MS
DJNZ R0, LOOP
POP 00H
RET

DELAY_1MS:
PUSH 00H
MOV R1, #4
LOOP5: ACALL DELAY_250US
DJNZ R1, LOOP5
POP 00H
RET

DELAY_250US:
PUSH 00H
MOV R2, #244
LOOP6: DJNZ R2, LOOP6
POP 00H
RET
end