# soym

## QEMU environment

Use a Default QEMU Setup for a Modern Computer

Well-supported: The -M pc machine emulates a standard IBM-PC–style platform, which modern laptops and desktops are built on.

Familiar hardware: CPU = x86_64, GPU = VGA-compatible, I/O = PS/2 keyboard, serial port → all classic, well-documented.

Easy graphics: With VGA text mode (0xB8000) or simple framebuffers, you can start drawing on the “screen” without writing a full GPU driver.

Rich ecosystem: The OSDev Wiki, hobby OS projects (e.g., xv6, Limine loaders) all use this configuration → lots of guides to lean on.

Cross-platform: Same setup runs on Linux, macOS, and Windows laptops → no special hardware needed.

✅ This gives you the fastest path from “bootloader” → “playable game.”

2. Components Provided in This QEMU Setup

When you run qemu-system-x86_64 -M pc -kernel kernel.bin, QEMU emulates these main parts:

CPU

Model: x86_64 (Intel/AMD-compatible).

Supports real mode (16-bit), protected mode (32-bit), and long mode (64-bit).

Comes with registers (RAX, RBX, RIP, RSP, etc.), control registers, MMU.

Memory

Emulates RAM (you can pick size, e.g., -m 256M).

At boot, CPU starts at a fixed reset vector (0xFFFFFFF0).

Includes memory-mapped I/O regions for devices.

Firmware

By default, QEMU boots with SeaBIOS (a BIOS implementation).

Optionally, you can use OVMF (UEFI).

This firmware initializes devices and then loads your kernel.

Display (GPU/VGA)

Default: VGA card (-vga std, -vga cirrus, etc.).

Text mode (80×25 chars at 0xB8000).

Graphics mode (mode 13h: 320×200, 256 colors at 0xA0000).

Lets you draw characters or pixels by directly writing to video memory.

Input Devices

Keyboard: PS/2 keyboard controller emulated.

Mouse: optional, but also PS/2-compatible.

You can capture keys directly → useful for games.

Timers

PIT (Programmable Interval Timer): old-school, but works for generating interrupts.

HPET / APIC timers: more modern, QEMU supports them.

You’ll use one of these to drive your game loop (“tick every X ms”).

Storage (Optional)

Can emulate hard disks, CD-ROMs, floppy disks.

Not needed for your project unless you want to load levels/files.

Serial Port

Useful for debugging.

With -serial stdio, all serial output goes to your terminal.

3. Computer Architecture of Each Piece (High-Level)

Let’s connect the dots as if you were designing a physical computer:

CPU

Core of the system, executes instructions.

Fetches instructions from memory, decodes, executes, writes back results.

Can address RAM and device registers via memory-mapped I/O.

Memory

Hierarchical architecture:

Registers (inside CPU)

Cache (L1/L2/L3)

RAM (main memory, where your kernel/game lives)

ROM/Flash (where firmware lives)

On reset, CPU executes from firmware location → sets up RAM → jumps to your code.

GPU (VGA)

Memory-mapped device with its own video RAM (VRAM).

When you write to VRAM (e.g., 0xB8000), the VGA controller renders that content to the “screen.”

Simple but powerful: you can update characters/pixels in real time.

I/O Devices (Keyboard, Timer, Serial)

Keyboard: CPU reads scancodes via I/O ports (0x60).

Timer: fires interrupts at regular intervals → lets your game run at steady FPS.

Serial: behaves like a byte stream → useful for logging or even multiplayer experiments.

Bus / Interconnect

Conceptually, all devices (RAM, VGA, keyboard, etc.) are connected over a system bus.

CPU uses this bus to talk to devices via memory addresses or I/O ports.

QEMU simulates this wiring automatically.

✅ So in short: the default QEMU “modern PC” setup is like a stripped-down laptop:

CPU = x86_64

Memory = RAM + ROM

GPU = VGA-compatible device (easy framebuffer)

Input = PS/2 keyboard

Timer = PIT/APIC

Bus = connects everything together

That’s enough to make a bootable game OS 🎮.

## Firmware
## Bare metal OS
## Game

