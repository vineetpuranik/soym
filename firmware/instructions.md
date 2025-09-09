## Firmware

* Now with QEMU installed, the next step would be to create a firmware.
  
* The role of the firmware
Firmware is the very first code the CPU executes after reset.
Its job is to initialize hardware and create a known starting state for higher-level code.
In our project, firmware will:
  Switch the CPU out of reset mode (16-bit real mode) into a usable state.
  Set up the stack and memory.
  Provide the first link between the CPU and devices (e.g., write to VGA memory, read keyboard input, configure the timer).
  Hand off control to a bare-metal OS or directly to an application (our game).
  
* How is firmware written ?
  Firmware is typically written in low-level languages:
  Assembly → absolute control over CPU instructions and hardware addresses.
  C (or Rust, with no_std) → after the CPU is initialized enough to support higher-level code.
  For a minimal system in QEMU:
  We start with a boot sector (512-byte binary) written in assembly.
  It contains CPU setup code and very simple routines (like writing a character to VGA).


* What is happening under the hood ?
  The CPU begins execution in real mode at the reset vector (0xFFFFFFF0).
  QEMU’s virtual BIOS (SeaBIOS) loads the first sector (512 bytes) of your disk/kernel image into memory at 0x7C00.
  The CPU jumps to 0x7C00 and executes your firmware instructions.

  At that point, your firmware has direct access to hardware:
  Writing to VGA memory at 0xB8000 → characters appear on screen.
  Reading from I/O port 0x60 → keyboard input is captured.
  Programming the PIT → timer ticks generate interrupts.
  
* What does QEMU virtual desktop that we build do with the firmware ?
  QEMU emulates a motherboard + CPU + devices (our virtual PC).
  When you run with -kernel kernel.bin:
  QEMU injects your firmware binary into the CPU’s memory at the right location.
  The virtual CPU starts executing it just like real hardware would.

  From QEMU’s perspective:
  Your firmware is treated as if it were a real BIOS/bootloader running on a real machine.
  Every memory write or port access your firmware does is handled by QEMU’s device models (VGA, PS/2 keyboard, PIT, serial, etc.).
  This means: even though you’re running on your laptop, your firmware is controlling a fully virtual computer inside QEMU.


