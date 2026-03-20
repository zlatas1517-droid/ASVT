.686
.model flat, stdcall
.stack 100h

ExitProcess PROTO STDCALL :DWORD

.data

X  word 0FC6Ah
Y  word 0F639h
Z  word 06132h

Xp word ?
Yp word ?
M  sdword ?
R  sdword ?

.code

main PROC

;  X' 
mov ax, X

or ax, 0008h     ; бит 3
or ax, 0080h     ; бит 7
or ax, 0800h     ; бит 11

mov Xp, ax


; Y'
mov ax, Y

and ax, 0FFFDh   ; сброс бит 1
and ax, 0FFBFh   ; сброс бит 6
and ax, 0F7FFh   ; сброс бит 11

mov Yp, ax


; (X' - Z)
movsx eax, Xp
movsx ebx, Z
sub eax, ebx
mov ecx, eax


; (Y' - Z) 
movsx eax, Yp
movsx ebx, Z
sub eax, ebx


; M
and eax, ecx
mov M, eax


; проверка знака M
cmp eax, 0
jl CALL_SUB1
jg CALL_SUB2


CALL_SUB1:
call SUB1
jmp CHECK_R


CALL_SUB2:
call SUB2
jmp CHECK_R


; проверка R 
CHECK_R:

mov eax, R
cmp eax, 9
jle ADR1
jg ADR2


; ADR1
ADR1:
mov eax, R
and eax, 4Ch
mov R, eax
jmp FINISH


; ADR2 
ADR2:
mov eax, R
or eax, 1001h
mov R, eax
jmp FINISH


FINISH:

invoke ExitProcess,0

main ENDP


; подпрограмма 1
SUB1 PROC
mov eax, M
add eax, 123
mov R, eax
ret
SUB1 ENDP


; подпрограмма 2 
SUB2 PROC
mov eax, M
sub eax, 999
mov R, eax
ret
SUB2 ENDP


END main