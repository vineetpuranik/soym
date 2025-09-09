; ================================
; boot.asm - Minimal Firmware (Boot Sector)
; ================================
; Purpose:
;   This is the first code the CPU executes after BIOS/SeaBIOS loads the
;   boot sector into memory at address 0x7C00. It demonstrates how firmware:
;     1. Starts in 16-bit real mode.
;     2. Sets up the stack (critical for safe execution).
;     3. Writes directly to VGA video memory (0xB8000).
;     4. Ends with the 0xAA55 signature so BIOS/QEMU recognizes it.

BITS 16                 ; Tell assembler: emit 16-bit instructions.
                        ; Why? At reset, x86 CPUs always start in "real mode".
                        ; In real mode, CPU can only directly address 1 MB of memory
                        ; using 16-bit segment:offset addressing (20-bit physical).

ORG 0x7C00              ; ORG sets the origin address for this code.
                        ; BIOS convention: the first sector (512 bytes) from bootable
                        ; media is loaded into memory starting at physical address 0x7C00.
                        ; Then CPU's instruction pointer is set to 0x7C00 and execution begins.
                        ; This tells NASM: "assume our code will be loaded at 0x7C00".

start:
    ; ------------------------------
    ; Setup the stack
    ; ------------------------------
    ; Why is this necessary?
    ;   - The stack is a reserved area of memory used for PUSH, POP, CALL, RET,
    ;     interrupts, and local storage.
    ;   - At reset, SS (Stack Segment) and SP (Stack Pointer) are undefined.
    ;     If we don't set them, any stack operation could overwrite random memory.
    ;   - Setting SS:SP ensures safe subroutine calls and interrupt handling.

    mov ax, 0x07C0       ; AX is a 16-bit general-purpose register.
                         ; We temporarily use it to hold the segment value.
                         ; Here we load 0x07C0, which will be assigned to SS.
                         ; Why AX? Because x86 only allows moving immediates into SS via AX.

    mov ss, ax           ; SS (Stack Segment) = 0x07C0.
                         ; Stack segment register defines the base segment for stack addresses.

    mov sp, 0x7C00       ; SP (Stack Pointer) = 0x7C00.
                         ; Stack pointer defines the current top-of-stack offset.
                         ; Together, SS:SP = 0x07C0:0x7C00.
                         ; Physical address = 0x07C0 * 16 + 0x7C00 = 0x7C00.
                         ; This means stack grows down from the boot sector address.
                         ; For our tiny example, this is fine, though normally you'd
                         ; set the stack elsewhere in free RAM.

    ; ------------------------------
    ; Write a character to VGA memory
    ; ------------------------------
    ; Video memory in text mode is mapped starting at physical address 0xB8000.
    ; Each screen cell = 2 bytes:
    ;   Byte 0 = ASCII character.
    ;   Byte 1 = Attribute (color info).
    ; Example: "A" (0x41) with attribute 0x07 (grey on black) is stored as 41 07.

    mov ah, 0x07         ; AH = high byte of AX.
                         ; Attribute 0x07 means light grey foreground, black background.

    mov al, 'O'          ; AL = low byte of AX.
                         ; ASCII value of 'O' is 0x4F.
                         ; Now AX = 0x074F → [AL=0x4F, AH=0x07].

    mov [0xB8000], ax    ; Store AX into memory location 0xB8000.
                         ; This writes two bytes:
                         ;   AL (0x4F → 'O') at 0xB8000.
                         ;   AH (0x07 → attribute) at 0xB8001.
                         ; Result: "O" appears in top-left of screen in grey on black.

hang:
    jmp hang             ; Infinite loop to keep CPU here forever.
                         ; Prevents execution from running into uninitialized memory.

; ------------------------------
; Boot sector padding and signature
; ------------------------------
times 510-($-$$) db 0    ; Fill the rest of the 512-byte boot sector with zeros
                         ; up to byte 510 (to ensure correct size).

dw 0xAA55                ; Mandatory boot signature: 0xAA55 (written little-endian).
                         ; This occupies the last 2 bytes (511 and 512).
                         ; BIOS/QEMU will only execute the sector if this marker exists.
