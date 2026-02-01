; 8086 assembly annotated version — every original line followed by a comment explaining it
.MODEL SMALL                               ; Use SMALL memory model: code and data in separate segments (<=64KB each)
.STACK 100h                               ; Reserve 0x100 (256) bytes for the stack

.DATA                                     ; Start of data segment (variables and strings)
    moisture db 0                         ; 1-byte variable 'moisture', initialized to 0 — stores moisture value (0..99)
    pump db 0                             ; 1-byte variable 'pump', initialized to 0 — 0=OFF, 1=ON
    
    msg1 db 'SMART IRRIGATION SYSTEM', 0Dh, 0Ah, '$'   ; Title string terminated by '$' for DOS AH=9 print
    msg2 db 'Enter soil moisture (0-100): ', '$'      ; Prompt asking user for moisture input
    msg3 db 0Dh, 0Ah, 'STATUS: DRY (0-50) - PUMP ACTIVATED', 0Dh, 0Ah, '$' ; Dry status message
    msg4 db 0Dh, 0Ah, 'STATUS: NORMAL (51-75) - PUMP OFF', 0Dh, 0Ah, '$'   ; Normal status message
    msg5 db 0Dh, 0Ah, 'STATUS: WET (76-100) - PUMP OFF', 0Dh, 0Ah, '$'      ; Wet status message
    msg6 db 'Pump State: ON - Watering...', 0Dh, 0Ah, '$'  ; Pump ON message
    msg7 db 'Pump State: OFF - No watering', 0Dh, 0Ah, '$' ; Pump OFF message
    msg8 db 0Dh, 0Ah, 'Test again? (Y/N): ',  0Dh, 0Ah,  '$'           ; Repeat prompt
    msg9 db 0Dh, 0Ah, 'System Stopped', 0Dh, 0Ah, '$'      ; Exit message
    
    ;db = “Define Byte”
    ;0Dh : Moves the cursor back to the start of the line
    ;0Ah : Moves the cursor down to the next line      
    ;'$' : STOP printing here
                                                
                                                
.CODE                                     ; Start of code segment
    MAIN PROC FAR                         ; Define MAIN procedure (FAR marker is assembler syntax)
        mov ax, @DATA                     ; Load AX with the segment address of the DATA segment (assembler symbol)
        mov ds, ax                        ; Set DS to point to DATA segment so memory references use correct segment

        ; Display title
        mov ah, 9                         ; DOS int21h function 09h = print '$'-terminated string at DS:DX
        lea dx, [msg1]                    ; Load DX with offset of msg1 (address relative to DS)             ;lea : It loads the memory address (offset) of a variable into a register — not the value stored there.
        int 21h                           ; Call DOS to print the title

    LOOP1:                                ; Label to mark loop start — used to repeat the process
        ; Ask for input
        mov ah, 9                         ; DOS print function again
        lea dx, [msg2]                    ; Load DX with prompt string address
        int 21h                           ; Print the prompt

        ; Read first digit
        mov ah, 1                         ; DOS int21h function 01h = read a single character (echoed)
        int 21h                           ; Returns ASCII char in AL
        
        cmp al, '0'                       ; Compare the typed character with ASCII '0'
        jb LOOP1                          ; If AL < '0' (unsigned) then it isn't a digit — restart loop
        cmp al, '9'                       ; Compare AL with ASCII '9'
        ja LOOP1                          ; If AL > '9' it's not a digit — restart loop
        
        sub al, '0'                       ; Convert ASCII digit to numeric value: '0'..'9' -> 0..9
        mov bl, al                        ; Save first digit numeric value in BL
        
        ; Read second digit
        mov ah, 1                         ; Read next character (could be a digit or Enter)
        int 21h                           ; ASCII returned in AL
        
        cmp al, 0Dh                       ; Compare AL with Carriage Return (Enter) ASCII 0x0D
        je STORE_VALUE                    ; If Enter pressed, treat input as a single-digit number and store it
        
        cmp al, '0'                       ; Check if second char is at least '0'
        jb STORE_VALUE                    ; If below '0' -> not a digit, store single-digit value
        cmp al, '9'                       ; Check if second char <= '9'
        ja STORE_VALUE                    ; If above '9' -> not a digit, store single-digit value
        
        sub al, '0'                       ; Convert second ASCII digit to numeric value
        mov cl, al                        ; Save second digit numeric value in CL
        
        ; Calculate: first_digit * 10 + second_digit
        mov ax, bx                        ; Move BX into AX — BX contains BL (first digit) in low byte; BH may be unknown
        mov bx, 10                        ; Put 10 into BX to multiply by 10
        mul bx                            ; Unsigned multiply AX * BX -> DX:AX (product). For small values DX = 0
        add al, cl                        ; Add second digit to low byte AL to form the final value (<=99)
        mov bl, al                        ; Store final value (0..99) in BL
        
    STORE_VALUE:
        mov moisture, bl                  ; Write BL into the 'moisture' variable in data memory

        ; Check thresholds
        mov al, moisture                  ; Load moisture value into AL for comparisons
        
        cmp al, 50                        ; Compare moisture with 50
        jle DRY_STATE                     ; If moisture <= 50 (signed compare) jump to DRY_STATE
        
        cmp al, 75                        ; Compare moisture with 75
        jle NORMAL_STATE                  ; If moisture <= 75 jump to NORMAL_STATE (this covers 51..75)
        
        ; WET (76-100)
        mov ah, 9                         ; Prepare to print the WET message
        lea dx, [msg5]                    ; Load offset of msg5 (WET message)
        int 21h                           ; Print WET status
        mov pump, 0                       ; Set pump variable to 0 (OFF) for wet condition
        jmp SHOW_PUMP                     ; Jump to code that prints pump state

    DRY_STATE:
        mov ah, 9                         ; Prepare to print DRY message
        lea dx, [msg3]                    ; Load offset of msg3 (DRY message)
        int 21h                           ; Print DRY status
        mov pump, 1                       ; Set pump to 1 (ON) because it's dry
        jmp SHOW_PUMP                     ; Jump to show pump state

    NORMAL_STATE:
        mov ah, 9                         ; Prepare to print NORMAL message
        lea dx, [msg4]                    ; Load offset of msg4 (NORMAL message)
        int 21h                           ; Print NORMAL status
        mov pump, 0                       ; Set pump to 0 (OFF) in normal condition

    SHOW_PUMP:
        cmp pump, 1                       ; Compare pump variable with 1
        je PUMP_ON                        ; If equal (pump==1) jump to PUMP_ON

        mov ah, 9                         ; Otherwise prepare to print pump OFF message
        lea dx, [msg7]                    ; Load offset of msg7 (Pump OFF)
        int 21h                           ; Print Pump OFF message
        jmp ASK_REPEAT                    ; After printing, ask user if they want to test again

    PUMP_ON:
        mov ah, 9                         ; Prepare to print pump ON message
        lea dx, [msg6]                    ; Load offset of msg6 (Pump ON)
        int 21h                           ; Print Pump ON message

    ASK_REPEAT:
        mov ah, 9                         ; Prepare to print "Test again? (Y/N): " prompt
        lea dx, [msg8]                    ; Load offset of msg8
        int 21h                           ; Print the prompt

        mov ah, 1                         ; Read one character from keyboard (echoed) into AL
        int 21h                           ; Character returned in AL

        cmp al, 'Y'                       ; Check if user pressed 'Y'
        je LOOP1                          ; If yes, jump back to LOOP1 to repeat
        cmp al, 'y'                       ; Also accept lowercase 'y'
        je LOOP1                          ; If yes, repeat

        ; Exit message
        mov ah, 9                         ; Prepare to print exit message
        lea dx, [msg9]                    ; Load offset of msg9 (System Stopped)
        int 21h                           ; Print exit message

        ; Exit program
        mov ax, 4C00h                     ; DOS terminate program: AH=4Ch, AL=return code (00)
        int 21h                           ; Call DOS to exit and return control to the OS/emu8086

    MAIN ENDP                          ; End of MAIN procedure
END MAIN                              ; Mark program entry point as MAIN
