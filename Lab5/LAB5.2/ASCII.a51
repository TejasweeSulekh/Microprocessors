ORG 0H
	LJMP MAIN

ORG 030H
MAIN:  MOV A,30H         ; move the numbers to be converted
       MOV B,#10H
       DIV AB
       CJNE A,#0AH,STAGE1 ; compare the number with A
	   ACALL LABEL2
	   MOV 60H,A
	   MOV A,B
	   JMP STAGE2
	  
	    
STAGE1: ACALL CHECK
    MOV 60H,A
    MOV A,B
	CJNE A,#0AH,STAGE2
	JMP LABEL2
	
STAGE2:
	ACALL CHECK
	MOV 61H,A
	HERE : SJMP HERE
	
CHECK: JNC LABEL2
       JC  LABEL1
	   
LABEL1:ADD A,#30H          ; If the number is lesser than A add with 30H
       RET
	   
LABEL2:ADD A,#37H          ;If the number is greater than A add with 37H
       RET
STOP:
       END
