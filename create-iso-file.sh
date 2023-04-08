#!/bin/bash

dd if=/dev/zero of=floppy.img bs=512 count=2880
dd if=itomos.bin of=floppy.img conv=notrunc

iso_dir=iso
if [ ! -d $iso_dir ]; then
    mkdir iso
fi

cp floppy.img iso/
genisoimage -quiet -V 'itomos' -input-charset iso8859-1 -o itomos.iso -b floppy.img -hide floppy.img iso/
brasero &
