$MOD51

        ORG     00H
        LJMP    START

        ORG     100H

START:
        MOV     P0, #0FFH
        MOV     P1, #0F0H       ; P1.7-P1.4 
        MOV     P2, #00H
        MOV     07H, #0FFH       ; Store last displayed key (0FFH = no key)
        MOV     06H, #0FFH       ; Store current pressed key
        MOV     05H, #00H        ; Flag: 0 = can display, 1 = already displayed once
        

; LCD INIT - Keep these delays as they're needed for LCD initialization
        MOV     P0, #038H
        MOV     P2, #1
        MOV     P2, #0
        LCALL   DELAY_5ms

        MOV     P0, #00CH
        MOV     P2, #1
        MOV     P2, #0
        LCALL   DELAY_5ms

        MOV     P0, #001H
        MOV     P2, #1
        MOV     P2, #0
        LCALL   DELAY_5ms

        MOV     P0, #080H       ; Set initial cursor position
        MOV     P2, #1
        MOV     P2, #0
        LCALL   DELAY_1ms

MAIN:
        LCALL   GET_KEY         ; Get current key press (returns 0FFH if no key)
        MOV     06H, A          ; Store current key state
        
        CJNE    A, #0FFH, KEY_PRESSED  ; If key pressed
        ; No key pressed - reset everything
        MOV     07H, #0FFH      ; Reset last displayed key
        MOV     05H, #00H       ; Reset display flag
        SJMP    MAIN

KEY_PRESSED:
        ; Check if we've already displayed a key after last release
        MOV     A, 05H
        CJNE    A, #00H, MAIN   ; If already displayed once (05H != 0), ignore all further keys
        
        ; Check if this key is different from last displayed
        MOV     A, 06H          ; Get current key
        CJNE    A, 07H, DISPLAY_NEW  ; If different from last displayed
        SJMP    MAIN            ; Same key, don't display again

DISPLAY_NEW:
        ; Display the digit on LCD
        MOV     A, 06H          ; Get current key
        MOV     P0, A           ; Send the digit to LCD
        MOV     P2, #3          ; Set RS=1, RW=0, EN=1
        MOV     P2, #2          ; Set RS=1, RW=0, EN=0 (latch data)
        LCALL   DELAY_SHORT     ; Short delay only
        
        MOV     07H, A          ; Store as last displayed key
        MOV     05H, #01H       ; Set flag - already displayed a key
        
        SJMP    MAIN


GET_KEY:
        ; Scan all rows and return the highest priority key (lower row has higher priority)
        ; Returns key ASCII code in A, or 0FFH if no key pressed
        
        ; Row 0 (P1.0 = 0) - Highest priority
        MOV     P1, #0F0H
        CLR     P1.0
        SETB    P1.1
        SETB    P1.2
        LCALL   DELAY_SHORT     ; Short delay for debouncing
        
        MOV     A, P1
        ANL     A, #070H
        CJNE    A, #070H, R0_CHECK
        SJMP    ROW1

R0_CHECK:
        ; Check columns in row 0
        JB      ACC.5, R0_C1
        MOV     A, #37H         ; '7' - Column 2
        RET
R0_C1:
        JB      ACC.4, R0_C0
        MOV     A, #34H         ; '4' - Column 1
        RET
R0_C0:
        JB      ACC.3, R0_END
        MOV     A, #31H         ; '1' - Column 0
        RET
R0_END:
        SJMP    ROW1

ROW1:
        ; Row 1 (P1.1 = 0)
        MOV     P1, #0F0H
        SETB    P1.0
        CLR     P1.1
        SETB    P1.2
        LCALL   DELAY_SHORT
        
        MOV     A, P1
        ANL     A, #070H
        CJNE    A, #070H, R1_CHECK
        SJMP    ROW2

R1_CHECK:
        JB      ACC.5, R1_C1
        MOV     A, #38H         ; '8' - Column 2
        RET
R1_C1:
        JB      ACC.4, R1_C0
        MOV     A, #35H         ; '5' - Column 1
        RET
R1_C0:
        JB      ACC.3, R1_END
        MOV     A, #32H         ; '2' - Column 0
        RET
R1_END:
        SJMP    ROW2

ROW2:
        ; Row 2 (P1.2 = 0)
        MOV     P1, #0F0H
        SETB    P1.0
        SETB    P1.1
        CLR     P1.2
        LCALL   DELAY_SHORT
        
        MOV     A, P1
        ANL     A, #070H
        CJNE    A, #070H, R2_CHECK
        MOV     A, #0FFH        ; No key pressed
        RET

R2_CHECK:
        JB      ACC.5, R2_C1
        MOV     A, #39H         ; '9' - Column 2
        RET
R2_C1:
        JB      ACC.4, R2_C0
        MOV     A, #36H         ; '6' - Column 1
        RET
R2_C0:
        JB      ACC.3, R2_END
        MOV     A, #33H         ; '3' - Column 0
        RET
R2_END:
        MOV     A, #0FFH        ; No key pressed (spurious detection)
        RET


; Short delay for key debouncing and fast LCD updates (~100us)
DELAY_SHORT:
        MOV     R5, #50
DS1:    DJNZ    R5, DS1
        RET

; 1ms delay for LCD commands
DELAY_1ms:
        MOV     R6, #2
D1:     MOV     R5, #250
D2:     DJNZ    R5, D2
        DJNZ    R6, D1
        RET

; 5ms delay for LCD initialization
DELAY_5ms:
        MOV     R6, #10
D3:     MOV     R5, #250
D4:     DJNZ    R5, D4
        DJNZ    R6, D3
        RET

; 50ms delay (kept for compatibility but not used)
DELAY_50ms:
        MOV     R6, #100
D5:     MOV     R5, #250
D6:     DJNZ    R5, D6
        DJNZ    R6, D5
        RET

        END