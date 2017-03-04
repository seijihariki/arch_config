Error (){
    echo -e "\e[0;31m$@\e[0m"
    exit
}

Info (){
    echo -e "\e[0;34m$@\e[0m"
}

pause (){
    read -p "\e[0;36mPress [Enter] to continue...\e[0m"
}

DEFLANG="en_US.UTF-8"
TIMEZONE="Brazil/East"
HOSTNAME="HOST_NAME"
GRUB_DEV="/dev/sda"

Info Uncomment necessary locales...
pause
nano /etc/locale.gen

Info Generating locales...
locale-gen

Info Generating locale.conf with en_US.UTF-8...
echo "$DEFLANG" > /etc/locale.conf

Info Setting timezone to $TIMEZONE...
ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc --utc

Info Changing root password...
passwd

Info Enter hostname:
read HOSTNAME
echo "$HOSTNAME" > /etc/hostname
systemctl enable dhcpcd || Error Could not enable dhcpcd

Info Installing grub...
pacman -S grub os-prober || Error Failed installing grub

Info Insert device to install grub:
read GRUB_DEV
grub-install $GRUB_DEV || Error Failed on grub-install
grub-mkconfig -o /boot/grub/grub.cfg || Error Could not grub-mkconfig
Info Script done for chroot.
Info Now, please exit chroot. Umount everything and reboot the computer.
Info Deleting script from root directory...
rm /run_on_chr.sh || Error Could not delete script
