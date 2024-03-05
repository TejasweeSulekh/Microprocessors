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
         DB   "ROLLING TIME", 00H

ORG 000BH
LCALL INTTIMER
RETI

ORG 350H
RESET:
	  mov a,#82h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay_LCD
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay_LCD
	  
MOV IE, #82H
MOV TCON, #11H
MOV TH0, #00H
MOV TL0, #0C0H

ACALL N1
MOV R3, #02H // HOW MANY MORE TIMES I WANT TO REPEAT THIS 
MOV R4, #03H // COUNTER FOR LOOP BREAK
ACALL DELAY_250ms
ACALL FREQ1

ACALL N2
MOV R3, #02H
MOV R4, #03H
ACALL DELAY_250ms
ACALL FREQ2

ACALL N3
MOV R3, #02H
MOV R4, #03H
ACALL DELAY_250ms
ACALL FREQ3

ACALL N2
MOV R3, #02H
MOV R4, #03H
ACALL DELAY_250ms
ACALL FREQ2

ACALL N4
MOV R3, #03H
MOV R4, #04H
ACALL DELAY_250ms
ACALL FREQ4

MOV R3, #01H
MOV R4, #02H
ACALL DELAY_250ms
ACALL SILENCE

ACALL N4
MOV R3, #03H
MOV R4, #04H
ACALL DELAY_250ms
ACALL FREQ4

ACALL N5
MOV R3, #03H
MOV R4, #04H
ACALL DELAY_250ms
ACALL FREQ5

LJMP TRUE_END

N1:
MOV TH1, #073H
MOV TL1, #0EFH
RET

N2:
MOV TH1, #083H
MOV TL1, #019H
RET

N3:
MOV TH1, #096H
MOV TL1, #02AH
RET 

N4:
MOV TH1, #0ACH
MOV TL1, #074H
RET

N5:
MOV TH1, #0A2H
MOV TL1, #050H
RET

INTTIMER:
MOV A, R2
JZ RTWOZERO
DJNZ R2, LOP1
RTWOZERO:
CJNE R2, #00H, CONT
DEC R4
MOV A, R3
JZ CONT
DJNZ R3, DELAY_250ms
CONT:
RET

DELAY_250ms:
	LCALL CLK
	RET
	
CLK:
	MOV R2,#05BH
LOP1:	
    CLR TF0
	
TIMER:
    MOV TH0, #00H
    MOV TL0, #0C0H
    SETB TR0
    RET

FREQ1:
CYCLE1:
    MOV P0, #00H
    MOV 30H, #1H
	MOV R0, 30H
	SETB P0.7	
	LCALL DELAYF
	
CYCLE2:
	MOV R0, 30H
	CLR P0.7
	LCALL DELAYF
	CJNE R4, #00H, FREQ1
	RET
	
DELAYF:	
	LCALL CLK1
	DJNZ R0, DELAYF 
	RET
	
CLK1:
	MOV R1,#02H
LP1:	
    CLR TF1
	ACALL N1
    DJNZ R1, TIMER1
	RET
	
TIMER1:	
    SETB TR1

LP: JNB TF1, LP
    JMP LP1

FREQ2:
CYCLE12:
    MOV P0, #00H
    MOV 30H, #1H
	MOV R0, 30H
	SETB P0.7	
	LCALL DELAYF2
	
CYCLE22:
	MOV R0, 30H
	CLR P0.7
	LCALL DELAYF2
	CJNE R4, #00H, FREQ2
	RET
	
DELAYF2:	
	LCALL CLK12
	DJNZ R0, DELAYF2 
	RET
	
CLK12:
	MOV R1,#02H
LP12:	
    CLR TF1
	ACALL N2
    DJNZ R1, TIMER12
	RET
	
TIMER12:	
    SETB TR1

LP2: JNB TF1, LP2
    JMP LP12
	
FREQ3:
CYCLE13:
    MOV P0, #00H
    MOV 30H, #1H
	MOV R0, 30H
	SETB P0.7	
	LCALL DELAYF3
	
CYCLE23:
	MOV R0, 30H
	CLR P0.7
	LCALL DELAYF3
	CJNE R4, #00H, FREQ3
	RET
	
DELAYF3:	
	LCALL CLK13
	ACALL N3
	DJNZ R0, DELAYF3 
	RET
	
CLK13:
	MOV R1,#02H
LP13:	
    CLR TF1
    DJNZ R1, TIMER13
	RET
	
TIMER13:	
    SETB TR1

LP3: JNB TF1, LP3
    JMP LP13

FREQ4:
CYCLE14:
    MOV P0, #00H
    MOV 30H, #1H
	MOV R0, 30H
	SETB P0.7	
	LCALL DELAYF4
	
CYCLE24:
	MOV R0, 30H
	CLR P0.7
	LCALL DELAYF4
	CJNE R4, #00H, FREQ4
	RET
	
DELAYF4:	
	LCALL CLK14
	DJNZ R0, DELAYF4 
	RET
	
CLK14:
	MOV R1,#02H
LP14:	
    CLR TF1
	ACALL N4
    DJNZ R1, TIMER14
	RET

TIMER14:	
    SETB TR1

LP4: JNB TF1, LP4
    JMP LP14

FREQ5:
CYCLE15:
    MOV P0, #00H
    MOV 30H, #1H
	MOV R0, 30H
	SETB P0.7	
	LCALL DELAYF5
	
CYCLE25:
	MOV R0, 30H
	CLR P0.7
	LCALL DELAYF5
	CJNE R4, #00H, FREQ5
	RET
	
DELAYF5:	
	LCALL CLK15
	DJNZ R0, DELAYF5 
	RET
	
CLK15:
	MOV R1,#02H
LP15:	
    CLR TF1
	ACALL N5
    DJNZ R1, TIMER15
	RET
	
TIMER15:	
    SETB TR1

LP5: JNB TF1, LP5
    JMP LP15
	

SILENCE: 
CJNE R4, #00H, SILENCE
RET

TRUE_END:
END