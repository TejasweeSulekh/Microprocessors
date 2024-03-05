ORG 00h
LJMP MAIN
ORG 120h
	
MAIN:

mov 50h, #07
mov 51h, #02
mov 52h, #20
mov 53h, #22

Display:

mov a, 50h
mov b, #10
div ab
swap a
mov p1, a
acall delay_200ms
mov a, b
swap a
mov P1,a
acall delay_200ms

mov P1, #0ffffh
acall delay_200ms


mov a, 51h
mov b, #10
div ab
swap a
mov p1, a
acall delay_200ms
mov a, b
swap a
mov P1,a
acall delay_200ms

mov P1, #0ffffh
acall delay_200ms

mov a, 52h
mov b, #10
div ab
mov p1, a
acall delay_200ms
mov a, b
swap a
mov P1,a
acall delay_200ms

mov a, 53h
mov b, #10
div ab
mov p1, a
acall delay_200ms
mov a, b
swap a
mov P1,a
acall delay_200ms

mov P1, #0fffh
acall delay_200ms

jmp Display

delay_200ms:
push 00h
mov r0, #20
h3: acall delay_10ms
djnz r0, h3
pop 00h
ret

delay_10ms:
push 00h
mov r0, #800
h2: acall delay_250us
djnz r0, h2
pop 00h
ret

delay_250us:
push 00h
mov r0, #244
h1: djnz r0, h1
pop 00h
ret


end