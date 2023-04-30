# MyOS: A Basic Custom Operating System

MyOS is a simple operating system built from scratch using Assembly. It provides a command prompt where users can enter a variety of supported commands, listed below.

## Demo Video:

[![Watch the demo](https://img.youtube.com/vi/-4x4dO1Bbu4/maxresdefault.jpg)](https://youtu.be/-4x4dO1Bbu4)

Upon starting the OS, an animation is displayed. The same animation can also be shown by executing the `draw` command. To reboot the system, use the `reboot` command.

## Supported Commands:

- `about` - Information about MyOS
- `help` - List of available commands
- `clear` - Clears the screen
- `reboot` - Reboots the system
- `ascii` - Displays the ASCII table
- `beep` - Produces a beep sound

- `writeflp head,track,sector,drive|size:` - Writes text data to the floppy disk (the same disk from which the OS is loaded)
- `readflp head,track,sector,drive|size:` - Reads text data from the floppy disk

Parameters for `writeflp` and `readflp` commands:
- `head` - {1, 2}
- `track` - [0-79]
- `sector` - [1-18]
- `drive` - {0, 1}
- `size` - Number of bytes to read/write (must be <= 6000)

`head,track,sector,drive` indicate the location on the floppy disk to read/write data.

- `chrono` - Counts seconds
- `fib n` - Calculates and displays the first `n` Fibonacci numbers
- `draw` - Displays an animated UTM (press Enter to stop the animation)

## Compilation

Rage 1791-1840

The `compile` script contains all the commands necessary to build:
 - `loader.com` from `loader.asm`
 - `wellcome.com` from `wellcome.asm`
 - `kernel.com` from `kernel.asm`

And it also contains the command that is necessary to create the bootable image from the `.com` files mentioned above, with the help of `appender3` script.

The `compile` file is a shell script. To do it's work run `./compile` (or: `bash compile`).

To build the source code it is requiredto have installed:
 - NASM version 2.14
 - bash shell
 - truncate
