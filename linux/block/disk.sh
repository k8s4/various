#!/bin/bash
disk="sda"

tune2fs -l /dev/$disk"1"
# tune2fs -m 0 $disk # set reserved space to 0

lsblk -Sfalt | grep $disk
sg_scan -i /dev/$disk

#sg_format -v --resize --count=-1 $disk
#sg_format -v --format --size=512 $disk

#blkdiscard -z $disk	# zero format

sync; echo 1 > /proc/sys/vm/drop_caches
