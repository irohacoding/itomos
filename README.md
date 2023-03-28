# itomos
An operating system

### STATUS:
Studying with passion! φ(●｀ε´●)

## 2023-03-28 hello, this is itomos!

hello from kernel.

`$ make`

`$ dd if=/dev/zero of=floppy.img bs=512 count=2880`

`$ dd if=itomos.bin of=floppy.img conv=notrunc`

`$ mkdir iso`

`$ cp floppy.img iso/`

`$ genisoimage -quiet -V 'itomos' -input-charset iso8859-1 -o itomos.iso -b floppy.img -hide floppy.img iso/`

`$ brasero`

Burn itomos.iso to DVD-RW media.

Insert media into my old pc (HP compaq nx4820) and setup BIOS Boot Menu to '2. ATAPI CD-ROM Drive' and run!

Yaaaa!

![itomos](2023-03-28.jpg)
