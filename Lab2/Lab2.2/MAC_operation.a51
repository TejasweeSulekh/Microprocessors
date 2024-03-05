ORG 0h
LJMP MAIN
ORG 100h
MAIN:
CALL MAC
HERE: SJMP HERE
ORG 130h
	
MAC:

mov 70h,#0ffh // Value for a1 //
mov 71h,#0ffh // Value for a2 //
mov 72h,#0ffh // Value for a3 //

mov 73h,#0ffh // Value for b1 //
mov 74h,#0ffh // Value for b2 //
mov 75h,#0ffh // Value for b3 //

mov A,70h
mov B,73h

mul AB // Multiply A and B and its result is stored in A and B itself where A contains lower bits and B contains higher bits //
mov 76h,A
mov 77h,B // For a1 and b1 //

mov A,71h
mov B,74h

mul AB
mov 78h,A
mov 79h,B // For a2 and b2 //

mov A,72h
mov B,75h

mul AB
mov 30h,A
mov 31h,B // For a3 and b3 //

mov 33h,76h
mov 32h,77h
mov 35h,78h
mov 34h,79h

CALL ADD16

mov A,#00h
addc A, #00h
mov 38h,A

mov 39h,36h // 0--7 //
mov 3Ah,37h // 8--15 //
mov 3Bh,38h // 16--23 //

mov 33h,39h
mov 32h,3Ah
mov 35h,30h
mov 34h,31h

CALL ADD16

mov A,3bh
addc A,#00h
mov 50H,A

mov 52h,36h

mov 51h,37h

RET

ADD16:

mov A,33h
add A,35h
mov 36h,A // LSB of A + B //

mov A, 32h
addc A,34h
mov 37h,A 

RET
END
