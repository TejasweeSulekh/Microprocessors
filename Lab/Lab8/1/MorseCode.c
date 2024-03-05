#include <at89c5131.h>
#include "lcd.h"				//Header file with LCD interfacing functions
#include "MorseCode.h"	//Header file for Morse Code 

sbit LED=P1^7;


/*
Port P0.7 is used for the audio signal output
*/	

void symbol1(void);
void symbol2(void);
void sybmol3(void);
void symbol4(void);
void symbol5(void);
unsigned char *s;


	void symbol1(void)
	{
			lcd_init();
			lcd_cmd(0x83);
			s = "Sending A";
			lcd_write_string(s);
			morsea();
		  
	}
	void symbol2(void)
	{
			lcd_init();
			lcd_cmd(0x83);
			s = "Sending B";
			lcd_write_string(s);
			morseb();
	}
	void symbol3(void)
	{
			lcd_init();
			lcd_cmd(0x83);
			s = "Sending C";
			lcd_write_string(s);
			morsec();
	}
	void symbol4(void)
	{
		lcd_init();
			lcd_cmd(0x83);
			s = "Sending D";
			lcd_write_string(s);
			morsed();
	}
	void symbol5(void)
	{
		lcd_init();
			lcd_cmd(0x83);
			s = "Sending E";
			lcd_write_string(s);
			morsee();
	}
	

//Main function

void main(void)
{
		
	//Call initialization functions
	lcd_init();
	
	
	// Read input nibble here
	
	
	if (P1_0)
	{
	  symbol1();
		msdelay(200);
	}
	else if (P1_1)
	{
		symbol2();
		msdelay(200);
	}
	else if (P1_2)
	{
		symbol3();
		msdelay(200);
	}
	else if (P1_3)
	{	
		symbol4();
		msdelay(200);
	}
	else
	{
		symbol5();
		msdelay(200);
	}
	
	// Insert Priority Logic
	
	
	// Inside each condition, call the functions from MorseCode.h. Fill functions in MorseCode.h

	// Write to LCD using function lcd_write_string() in side the condition as well
	
	
	// 
	
	
}