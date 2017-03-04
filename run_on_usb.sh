Error (){
    echo -e "\e[0;31m$@\e[0m"
    exit
}

pause (){
    read -p "\e[0;36mPress [Enter] to continue...\e[0m"
}

echo -e "\e[1;34mChecking if internet is available...\e[0m"
ping google.com -c 1 || Error Internet not available
echo -e "\e[1;32mConnection OK! Starting installation...\e[0m"

echo -e "\e[1;34mWill now configure partitions.\e[0m"
pause
cfdisk || Error failed setting up partitions
echo -e "\e[1;32mPartitions set up. Enter partitions for formatting:\e[0m"
read partitions
for partition in $partitions; do
    mkfs.ext4 $partition
done
echo -e "\e[1;34mEnter swap partition:\e[0m"
read partition
echo -e "\e[1;34mInitializing swap partition...\e[0m"
mkswap $partition
swapon $partition
echo -e "\e[1;34mPlease mount partitions with /mnt as root, as desired. When finished, run 'exit'.\e[0m"
bash || sh
echo -e "\e[1;34mInstalling Arch system...\e[0m"
pacstrap /mnt base || Error Could not install system
echo -e "\e[1;34mGenerating fstab...\e[0m"
genfstab /mnt || Error fstab generation failed
echo -e "\e[1;32mThis script was finished successfully. Will now enter on the new system. Run the next script on the new system to continue. It will be copied to the root of the new system.\e[0m"
pause
cp run_on_chr.sh /mnt || Error Script could not be copied!
arch-chroot /mnt /bin/bash || Error Chroot failed!
