### Multipath and LVM setup

Multipathing ensures that the system uses multiple physical paths to provide redundancy and increased throughput.

### How to install multipath in ubuntu:
```bash
sudo apt-get install multipath-tools
```
next to check luns visibility scan scsi with below command 
```bash
vi /etc/multipath.conf 
```
add below lines in multipath.conf
```bash
defaults {
    user_friendly_names yes
    path_grouping_policy multibus
}
```
save and exit
restart multipath-tools
```bash
systemctl restart multipath-tools.service
```
after restart /etc/multipath/bindings file will be created automatically
to check the status of multipath
```bash
multipath -l
```
To scan visible LUNS in the server
```bash
/usr/bin/rescan-scsi-bus.sh
```
to check multipath devices
```bash
multipath -ll
```
**Manually** 
if creating intially,copy wwid number obtained from "multipath ll" command.which shows partion name and wwid numbers,copying new wwid no's 
 to /etc/multipath/wwid and restarting services
 
 ### LVM creation for multipath enabled storage
 
 ```bash
 ls -l /dev/mapper
 ```
 ```bash
 fdisk -l /dev/mapper/mpatha
 ```
 ```bash
 fdisk -l /dev/mapper/mpathb
```
 where /dev/mapper/mpatha,mpathb are multipath enabled partions available volumes.
 #### To create physical volumes
 ```bash
 pvcreate /dev/mapper/mpatha``
 ```
 ```bash
 pvcreate /dev/mapper/mpathb``
 ```
 ```bash
 pvs
 ```
 shows physical volumes created
 ```bash
 pvdisplay
 ```
 #### To create volume group
 ```bash 
 vgcreate vgname /dev/mapper/mpatha /dev/mapper/mpathb
 ```
 where vgname is volume group name given and /dev/mapper/mpatha are physical volumes
 To display volume groups
 ```bash
 vgs
 ```
 ```bash
 vgdisplay
 ```
 #### To create Logical volumes
 ```bash
 lvcreate -l 100%FREE -n lgname vgname
 ```
 ```bash
 lgname is logical volume name
 ```
 ```bash
 vgname is volume group name
 ```
 to check logical volumes
 ```bash
 lvs
 ```
 ```bash
 lvdisplay
 ```
 #### Now format newly created logical volumes to specific filesystem.
 ```bash
 mkfs.ext4 /dev/lgname/vgname
 ```
 where ext4 is the filesystem
 to check the status
 ```bash
 fdisk -l
 ```
**Mount the partion to required path**
```bash
mount/dev/lgname/vgname /var
```
To permanently mount :
```bash
blkid
```
above command displays UUID no's adding it in /etc/fstab for partions to appear after reboot.
```bash
vi /etc/fstab
``UID=93838619-6c00-472b-af9b-686ea58faa95 /var ext4  defaults   0     2
save and exit.
```
### To extend LVM partions from LUNS

firstly scan available storage from below command 
```bash
/usr/bin/rescan-scsi-bus.sh
```
restart multipath-tools
```bash
/etc/init.d/multipath-tools restart
```
check LUN partions availabe from below command
```bash
multipath -ll
```
**to create LVM partion and increase logical volume size**
```bash
fdisk /dev/mapper/mpathc
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
```
command to intialize in kernel level
**To create physical volumes**
```bash 
fdisk -l /dev/mapper/mpathc
```
you find device name
```baash
pvcreate /dev/mapper/mpathc-part1
```
where /dev/mapper/mpathc-part1 is device name obtained from fdisk -l command
```bash
pvs
```
shows physical volumes
```bash
vgs
```
```bash
vgextend vgname /dev/mapper/mpathc-part1
```
```bash
vgs
```
To see which pv is used to create volume group
```bash
pvscan
```
```bash
vgdisplay
```
from last second line
Free PE / Size 271359 / 1.04 TiB
shows free space available
```bash
lvextend -l +271359 /dev/lgname/vgname
```
where /dev/lgname/vgname is logicalvolume
To use new partion
```bash
resize2fs /dev/lgname/vgname
```
To check changes
```bash
lvs
```
```bash
lvdisplay
```
```bash
df -h
```
check the new partions

