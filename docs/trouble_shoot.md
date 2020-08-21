# Trouble Shooting

## Could not create VolumeGroup by lvm2.

### Your system isn't using 'scsi' devices.

By default, volume group is created to use 'scsi' storage devices by lvm2.

If you use 'nvme' or 'ata' storage devices, you must edit file, 'role/topolvm/tasks/install_lvm2.yaml'.

How to check using device type.

```console
$ ls /dev/disk/by-id
ata-SanDisk_SDSSDH3_500G_xxxxxxxxxxxxxx
nvme-INTEL_SSDPED1D960GAY_xxxxxxxxxxxxx
```

You need replace 'scsi' of 2 parts to 'ata' or 'nvme' in the following code that line 11 and line 13 of task, vgcreate '{{ vg_configuration.VGNAME }}'. 

```yaml
OS_DISK=$(ls -al /dev/disk/by-id/ | sed -e 's/\ /\n/g' | grep scsi | grep .*-part. | sed -n 1P | sed -e 's/\-part.//g')

for ID in `ls -al /dev/disk/by-id/ | grep -v -e 'sr0' -e $OS_DISK | sed -e 's/\ /\n/g' | grep 'scsi'`
```

### Creating VMs by ESXi

LVM search storage devices to create volume group from /dev/disk/by-id in this Playbook.

Following Site, There is no link in /dev/disk/by-id

https://www.suse.com/support/kb/doc/?id=000016951

> By default VMWare doesn't provide information needed by udev to generate /dev/disk/by-id.

So, you must set that ESXi provide information needed by udev to generate /dev/disk/by-id.

