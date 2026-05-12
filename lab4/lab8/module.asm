.586
.model flat, C

.code

extern func:near
public Sum

Sum PROC C

    push ebp
    mov ebp, esp

    finit
    fldz

    mov ecx, [ebp+8]
    xor eax, eax

L1:
    cmp ecx, 0
    jl L2

    push ecx

    push eax
    push dword ptr [ebp+16]
    push dword ptr [ebp+12]

    call func

    add esp, 12

    faddp st(1), st(0)

    pop ecx

    inc eax
    dec ecx
    jmp L1

L2:
    mov esp, ebp
    pop ebp
    ret

Sum ENDP

end