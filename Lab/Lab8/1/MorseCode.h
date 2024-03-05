/*************************************************
 	lcd.h: Header file for 16x2 LCD interfacing  
**************************************************/
//Functions contained in this header file

void dashtone(void);																//Dash tone generator
void dottone(void);																	//Dot tone generator


void morse_a(void);																	//morse code for A
void morse_b(void);																	//morse code for B
void morse_c(void);																	//morse code for C
void morse_d(void);																	//morse code for D
void morse_e(void);																	//morse code for E
//Function definitions

void dashtone(void) 
{ 
	
	unsigned i;
	for(i=0;i< 1370 ;i++){
	P0_7 = ~P0_7;
	msdelay(1); 		
		/* This function is a welcome change over the hardwork in the delay subroutines in earlier labs :D*/
	}
}
void dottone(void)
{ 
  // Similar to dashtone
  unsigned j;
  for(j=0;j< 684 ;j++){
  P0_7 = ~P0_7;
  msdelay(1);
  }

}

void morsea(void)// .-
{
	dottone();
	msdelay(973);
	dashtone();
	P0_7 = 0;
	msdelay(950);
	
}

void morseb(void)// -...
{
// Insert
      dashtone();
	P0_7 = 0;
      msdelay(973);
      dottone();
	P0_7 = 0;
      msdelay(973);
      dottone();
	P0_7 = 0;
      msdelay(973);
      dottone();
	P0_7 = 0;
	msdelay(950);
 	


}
void morsec(void)// -.-.
{
// Insert
	dashtone();
	P0_7 = 0;
	msdelay(973);
	dottone();
	P0_7 = 0;
	msdelay(973);
	dashtone();
	P0_7 = 0;
	msdelay(973);
	dottone();
	P0_7 = 0;
	msdelay(950);

}
void morsed(void)// -..
{
// Insert
	dashtone();
	P0_7 = 0;
	msdelay(973);
	dottone();
	P0_7 = 0;
	msdelay(973);
	dottone();
	P0_7 = 0;
	msdelay(970);
}
void morsee(void)// .
{
// Insert
	dottone();
	P0_7 = 0;
	msdelay(950);
}
