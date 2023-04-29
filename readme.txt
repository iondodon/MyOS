Rage 1791-1840

The compile file contains all the commands necessary to build:
 - loader.com from loader.asm
 - wellcome.com from wellcome.asm
 - kernel.com from kernel.asm

And it also contains the command that is necessary to create 
the bootable image from the built files mentioned above, 
with the help of appender3 script.

The compile file is a shell script. To do it's work run ./compile (or: bash compile) .

To build the source code it is requiredto have installed:
 - NASM version 2.14
 - bash shell
 - truncate


Supported commands:

- about
- ascii
- help
- clear
- reboot
- beep
- writeflp 
- readflp 
- chrono
- fib 
- draw
