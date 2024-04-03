#!/bin/bash

# Step 1: Old and New volume details using lsblk
size=$size
mount_point=$mount_point
os_version=$(lsb_release -rs)
new_device_name=$(lsblk -o NAME,SIZE | grep "${size}G$" | awk '{print $1}')
old_device_name=$(lsblk -o NAME,MOUNTPOINT | grep "$mount_point" | awk '{print $1}')
format_type=$(df -hT | awk "{ if(\$7 == \"$mount_point\") print \$2 }")

echo "Device_Name: $new_device_name"
echo "Format_Name: $format_type"

if [ -n "$new_device_name" ]; then
    # Step 1: Format the new volume
    
    if [ "$format_type" = "ext4" ]; then
        sudo file -s /dev/$new_device_name
        sudo mkfs.ext4 /dev/$new_device_name
        # Step 2: Create mount directory
        sudo mkdir -p /mnt/vol_name
        # Step 3: Mount the new volume
        sudo mount /dev/$new_device_name /mnt/vol_name
        # Step 4: Copy data from old volume to new volume using RSYNC
        sudo rsync -axv $mount_point /mnt/vol_name/
        # Step 5: Grub Installation
        sudo grub-install --root-directory=/mnt/vol_name --force /dev/$new_device_name
        # Step 6: Check the disk for errors
        sudo e2fsck -f /dev/$new_device_name
        # Step 7: Unmount the new volume
        sudo umount /mnt/vol_name
        # Step 8: Root UUID and blkid
        ROOT_DEV=`sudo blkid -L cloudimg-rootfs`
        SAVED_UUID_ORIGINAL_FILESYSTEM=`blkid -s UUID -o value $ROOT_DEV`
        # Step 9: Replace UUID on the new volume
        sudo tune2fs -U "$SAVED_UUID_ORIGINAL_FILESYSTEM" /dev/$new_device_name
        #Step 10: Copy the Label across root volume
        LABEL=`sudo e2label $ROOT_DEV`
        sudo e2label /dev/$new_device_name $LABEL
    elif [ "$format_type" = "xfs" ]; then
        sudo mkfs.xfs /dev/$new_device_name
        # Step 1: Create mount directory
        sudo mkdir -p /mnt/vol_name
        # Step 2: Mount the new volume
        sudo mount /dev/$new_device_name /mnt/vol_name
        # Step 3: Copy data from old volume to new volume using RSYNC
        sudo rsync -axv $mount_point/ /mnt/vol_name/
        # Step 4: Unmount the new volume
        sudo umount /mnt/vol_name
        # Step 5: Find and store the UUID of the original filesystem
        SAVED_UUID_ORIGINAL_FILESYSTEM=$(sudo blkid -o value -s UUID /dev/$old_device_name)
        # Step 6: Check the disk for errors
        sudo e2fsck -f /dev/$new_device_name
        # Step 7: Replace UUID on the new volume
        sudo xfs_admin -U "$SAVED_UUID_ORIGINAL_FILESYSTEM" /dev/$new_device_name

        # Step 8: Taking backup of /etc/fstab
        cp /etc/fstab /etc/fstab.bak

        # Step 9: Modifying fstab file
        if grep -q '$old_device_name' /etc/fstab; then
            sudo sed -i 's,$old_device_name,#$old_device_name,' /etc/fstab
            echo "UUID=$SAVED_UUID_NEW_FILESYSTEM   $mount_point    xfs    defaults    0 0" >> /etc/fstab
        elif grep -q '/dev/xvdf' /etc/fstab; then
            sudo sed -i 's,/dev/xvdf,#/dev/xvdf,' /etc/fstab
            echo "UUID=$SAVED_UUID_NEW_FILESYSTEM   $mount_point    xfs    defaults    0 0" >> /etc/fstab
        else
            sudo sed -i 's,LABEL,#LABEL,' /etc/fstab
            echo "LABEL=cloudimg-rootfs    /    ext4    defaults,discard    0 0" >> /etc/fstab
        fi   
        sudo umount $mount_point
        sudo mount /dev/$new_device_name $mount_point
    fi
else
    echo "No new volume found."
fi

rm /tmp/remote.sh