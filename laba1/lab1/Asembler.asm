.686
.model flat, stdcall
.stack 100h

.data
; Исходные данные для 16-го варианта
X   dw  8           ; X = 8 (0008h)
Y   dw  -5          ; Y = -5 (FFFBh)
Z   dw  14          ; Z = 14 (000Eh)

X1  dw  ?           ; X' = RCR X, 6
Y1  dw  ?           ; Y' = RCR Y, 6
Z1  dw  ?           ; Z' = RCR Z, 6
M   dw  ?           ; M = (Z+X+Y) OR (X'+Y'+Z')

.code
ExitProcess PROTO STDCALL :DWORD

Start:
    ; === Вычисляем X' = RCR X, 6 ===
    mov ax, X      ; AX = X (8)
    mov cl, 6        ; счетчик сдвига = 6
    clc              ; сбрасываем флаг переноса CF = 0
    rcr ax, cl       ; циклический сдвиг вправо через перенос на 6 бит
    mov X1, ax     ; сохраняем X'

    ; === Вычисляем Y' = RCR Y, 6 ===
    mov ax, Y      ; AX = Y (-5 = FFFBh)
    mov cl, 6
    clc
    rcr ax, cl
    mov Y1, ax     ; сохраняем Y'

    ; === Вычисляем Z' = RCR Z, 6 ===
    mov ax, Z      ; AX = Z (14 = 000Eh)
    mov cl, 6
    clc
    rcr ax, cl
    mov Z1, ax     ; сохраняем Z'

    ; === Вычисляем первую часть: (Z + X + Y) ===
    mov ax, Z      ; AX = Z (14)
    add ax, X      ; AX = Z + X (14 + 8 = 22)
    add ax, Y      ; AX = Z + X + Y (22 + (-5) = 17)
    mov bx, ax       ; сохраняем (Z+X+Y) в BX = 17 (0011h)

    ; === Вычисляем вторую часть: (X' + Y' + Z') ===
    mov ax, X1     ; AX = X'
    add ax, Y1     ; AX = X' + Y'
    add ax, Z1     ; AX = X' + Y' + Z'

    ; === Вычисляем M = (Z+X+Y) OR (X'+Y'+Z') ===
    or ax, bx        ; AX = (Z+X+Y) OR (X'+Y'+Z')
    mov M, ax      ; сохраняем результат в M



exit:
    invoke ExitProcess, 0
End Start