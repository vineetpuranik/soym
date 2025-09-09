## Host system details

Host operating system and version : lsb_release -a
* Operating system : Linux
* Distributor ID: Ubuntu
* Description Ubuntu 22.04.05 LTS
* Release : 22.04
* Codename : Jammy

Host CPU architecture : uname -m
* x86_64 = 64 bit instruction set architecture (ISA)
* This is used by Intel and AMD CPUs
* It can execute 64 bit instructions and also legacy 32 and 16 bit instructions.
* QEMU will by defaul emulate an x86_64 machine. However, we can still emulate other ISAs like ARM, RISC-V

Host virtualization support : 
* In order for QEMU to run faster, use KVM (Linux)
* Run egrep -c '(vmx|svm)' /proc/cpuinfo : Output is 8 => Host CPU has 8 logical processors (cores) that support hardware virtualization.
* lscpu | grep -i virtualization → Virtualization: AMD-V → Host CPU supports AMD-V → Significance: allows near-native speed with KVM
* lsmod | grep kvm → Kernel modules loaded: kvm, kvm_amd, irqbypass → hardware acceleration available

Host Kernel / Firmware details : 
* These details are not needed for QEMU installation. QEMU runs in user space and it emulates the firmware for the guest. Hence, host kernel and firmware do not matter.


## Installing QEMU on Ubuntu 22.04
* sudo apt update
* sudo apt install qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y
* What these do:
  qemu → base QEMU emulator binaries
  qemu-kvm → enables KVM acceleration on your AMD-V CPU
  libvirt-daemon-system + libvirt-clients → virtualization service (lets you manage VMs more easily)
  bridge-utils → networking tools if you ever want your VM to use host networking
  virt-manager → optional GUI manager (you may not use it, but it’s handy for testing)
* Verify installation qemu-system-x86_64 --version => QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.26)
* Verify KVM acceleration : kvm-ok => INFO: /dev/kvm exists ; KVM acceleration can be used
