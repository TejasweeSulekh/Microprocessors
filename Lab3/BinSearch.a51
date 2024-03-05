org 0h 
call delay_1ms
delay_1ms:
push 00h
mov r0, #4
h2: call delay_250us
djnz r0, h2
pop 00h
ret
delay_250us:
push 00h
mov r0, #244
h1: djnz r0, h1
pop 00h
ret