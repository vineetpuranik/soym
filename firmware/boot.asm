; ================================
; boot.asm - Minimal Boot Sector
; ================================
; Purpose:
;   This is the smallest possible boot sector that will:
;     1. Be recognized by BIOS/QEMU as bootable (because of the 0xAA55 signature).
;     2. Use BIOS interrupt 0x10 (video services) to print a single character ('X').
;     3. Enter an infinite loop to keep the CPU from executing garbage.
;
;   This proves: our boot sector is valid and BIOS actually executes our code.

BITS 16                 ; Assemble for 16-bit mode, since x86 CPUs always
                        ; start in "real mode" after reset.

ORG 0x7C00              ; BIOS convention: it loads the boot sector (512 bytes)
                        ; into physical memory at address 0x7C00, then jumps there.
                        ; ORG tells the assembler to treat 0x7C00 as our starting offset.

start:
    ; ------------------------------
    ; Print character using BIOS
    ; ------------------------------
    ; We use BIOS interrupt 0x10, service 0x0E ("teletype output").
    ; Inputs:
    ;   AH = 0x0E → select teletype service.
    ;   AL = ASCII code of character to print.
    ;   BH = page number (default 0).
    ;   BL = text attribute (for some video modes, ignored here).
    ;
    ; BIOS will:
    ;   - Write the character in AL to the current cursor position.
    ;   - Advance the cursor to the next position.

    mov ah, 0x0e         ; Select BIOS teletype output function (INT 0x10, service 0x0E).
    mov al, 'X'          ; ASCII code for 'X' (0x58).
                         ; This is the character BIOS will draw on the screen.

    int 0x10             ; Trigger BIOS video interrupt 0x10.
                         ; BIOS executes its teletype service and prints 'X'
                         ; on the screen (usually right after "Booting from Hard Disk...").

    ; ------------------------------
    ; Halt by looping forever
    ; ------------------------------
    ; After printing, we don't want CPU to continue into random memory.
    ; So we jump to ourselves infinitely.
    jmp $                ; "$" means "current address", so "jmp $" = infinite loop.

; ------------------------------
; Boot sector padding + signature
; ------------------------------
times 510-($-$$) db 0    ; Pad file with zeros until we reach byte offset 510.
                         ; This ensures the boot sector is exactly 512 bytes.

dw 0xAA55                ; Mandatory boot signature (little-endian).
                         ; Bytes 511–512 contain 55h AAh.
                         ; BIOS/QEMU checks this to decide if the sector is bootable.
