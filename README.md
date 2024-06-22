# Coconut
Coconut is a simple single stage x86 legacy bootloader. Note that it currently only supports booting in real mode as this project was dropped in favour of making an UEFI bootloader.

## Features
Coconut is small so it fits completely inside the boot sector of a disk, and will try to read the sector right after for a header which it will then read and use to load the rest into memory at the requested segments and addresses. Examples can be found in the [examples directory](examples/).

## Using
To use Coconut you need to write it to the boot sector of a disk or load it in a virtual machine.

To write it to a disk you can use the `dd` command like this:
```bash
dd if=./coconut.bin of=<target device> bs=512 count=1
```
where `<target device>` is the disk you want to write to e.g. `/dev/sda`. Be careful though as `dd` has commonly been referred to as the 'disk destroyer'.

The alternative way to test it is using a virtual machine like `qemu`, which in this case the [makefile](Makefile) already handles for you. Running `make run` will run `qemu` with a disk containing Coconut concatenated with the file `bootable.bin` if it exists. The easiest way to create a `bootable.bin` is by running:
```bash
nasm -f bin ./examples/helloworld16.s -o bootable.bin
```

### Building
Building Coconut is as easy as running make:
```bash
git clone https://github.com/Chimplement/slog.git slog
cd slog
make
```

## Future
For now there are no plans to continue work on coconut, but a couple of things I would like to add in the future include protected and virtual mode support as well as collecting more information from the bios while still in real mode.