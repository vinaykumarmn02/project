###Multipath and LVM setup

Multipathing ensures that the system uses multiple physical paths to provide redundancy and increased throughput.

###How to install multipath in ubuntu:
``sudo apt-get install multipath-tools
next to check luns visibility scan scsi with below command 
``vi /etc/multipath.conf 
add below lines in multipath.conf
``defaults {
  ``user_friendly_names yes
  ``path_grouping_policy multibus
``}
save and exit
restart multipath-tools
``# systemctl restart multipath-tools.service
after restart /etc/multipath/bindings file will be created automatically
to check the status of multipath
``multipath -l
To scan visible LUNS in the server
``/usr/bin/rescan-scsi-bus.sh
to check multipath devices
``multipath -ll
**Manually** 
if creating intially,copy wwid number obtained from "multipath ll" command.which shows partion name and wwid numbers,copying new wwid no's 
 to /etc/multipath/wwid and restarting services
 
 ###LVM creation for multipath enabled storage
 
 ``ls -l /dev/mapper
 ``fdisk -l /dev/mapper/mpatha
 ``fdisk -l /dev/mapper/mpathb
 where /dev/mapper/mpatha,mpathb are multipath enabled partions available volumes.
 ####To create physical volumes
 ``pvcreate /dev/mapper/mpatha
 ``pvcreate /dev/mapper/mpathb
 ``pvs
 shows physical volumes created
 ``pvdisplay
 ####To create volume group
 ``vgcreate vgname /dev/mapper/mpatha /dev/mapper/mpathb
 where vgname is volume group name given and /dev/mapper/mpatha are physical volumes
 To display volume groups
 ``vgs
 ``vgdisplay
 ####To create Logical volumes
 ``lvcreate -l 100%FREE -n lgname vgname
 lgname is logical volume name
 vgname is volume group name
 to check logical volumes
 ``lvs
 ``lvdisplay
 ####Now format newly created logical volumes to specific filesystem.
 ``mkfs.ext4 /dev/lgname/vgname
 where ext4 is the filesystem
 to check the status
 ``fdisk -l
**Mount the partion to required path 
``mount/dev/lgname/vgname /var
To permanently mount :
``blkid
above command displays UUID no's adding it in /etc/fstab for partions to appear after reboot.
``vi /etc/fstab
``UID=93838619-6c00-472b-af9b-686ea58faa95 /var ext4  defaults   0     2
save and exit.
###To extend LVM partions from LUNS

firstly scan available storage from below command 
``/usr/bin/rescan-scsi-bus.sh
restart multipath-tools
``/etc/init.d/multipath-tools restart
check LUN partions availabe from below command
``multipath -ll
**to create LVM partion and increase logical volume size
``fdisk /dev/mapper/mpathc
type n
partion type p
partion number
click default values
``Command (m for help): t
8e
``Command (m for help): w
save changes
the partion table is altered
``partprobe
command to intialize in kernel level
**To create physical volumes
``fdisk -l /dev/mapper/mpathc
you find device name
``pvcreate /dev/mapper/mpathc-part1
where /dev/mapper/mpathc-part1 is device name obtained from fdisk -l command
``pvs
shows physical volumes
``vgs
``vgextend vgname /dev/mapper/mpathc-part1
``vgs
To see which pv is used to create volume group
``pvscan
``vgdisplay
from last second line
Free PE / Size 271359 / 1.04 TiB
shows free space available
``lvextend -l +271359 /dev/lgname/vgname
where /dev/lgname/vgname is logicalvolume
To use new partion
``resize2fs /dev/lgname/vgname
To check changes
``lvs
``lvdisplay
``df -h
