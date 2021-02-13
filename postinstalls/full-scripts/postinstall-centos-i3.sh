#! /bin/bash
#
# first install centos minimal, then
# wget https://framagit.org/efydd/config/raw/master/.postinstall/centos_i3.sh

######################### VARIABLES

# colors
RED="\033[1;31m"
COLOR_OFF="\033[0m"
# define the main user
MYUSER=$(cat /etc/passwd | grep home | cut -d ":" -f 1)

######################### PERMISSIONS

# use it at root
if [ $EUID -ne 0 ] ; then
  echo "#################################################################"
  echo -e "${RED}/""!""\\"" ${COLOR_OFF} You must be root to play that script. Please try again.  ""${RED}/""!""\\"" ${COLOR_OFF}"
  echo "#################################################################"
  exit 1
fi
# stop if some error
#set -e

######################### START

clear

# banner and time
echo
echo -e "        ${RED} ########################################## ${COLOR_OFF}"
echo -e "        ${RED} # Fedora fast install (less than an hour)  ${COLOR_OFF}"
echo -e "        ${RED} ########################################## ${COLOR_OFF}"
echo
echo "start at $(date +\%F\ \%H:%M)"
echo

# epel repository
echo -e "        ${RED} # Add the epel repositories (must have for a desktop application) ${COLOR_OFF}"
yum -y install epel-release
#yum-config-manager --enable extras #if yum-utils
yum check-update
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# install and config of the firewall
echo -e "        ${RED} # Set the firewall to drop all input (open only if needed) ${COLOR_OFF}"
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=drop
firewall-cmd --complete-reload
systemctl disable sshd
systemctl stop sshd
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# install graphical mode
echo -e "        ${RED} # Install the i3 windows manager ${COLOR_OFF}"
yum -y groupinstall "X Window System"
yum -y install lightdm xorg-x11-xinit-session dejavu-sans-mono-fonts i3 i3status
systemctl set-default graphical.target
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# install my softwares
echo -e "        ${RED} # Install only the packages you need ${COLOR_OFF}"
myprogram="
bleachbit
encfs
feh #yum -y install libcurl-devel libX11-devel libXt-devel libXinerama-devel libpng-devel
firefox
prename
ranger
rxvt-unicode"
yum install -y $myprogram
yum upgrade --refresh -y
yum clean packages -y
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# config for SSD
echo -e "        ${RED} # Configuration of mount point for SSD (better performance) ${COLOR_OFF}"
sed -i 's/defaults/defaults,discard/g' /etc/fstab
sed -i 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf
echo noop | tee /sys/block/sda/queue/scheduler
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# autologin (only for encrypt HDD)
echo -e "        ${RED} # If you use an encrypt HDD, you can autologin to lightdm ${COLOR_OFF}"
groupadd -r autologin -g 1001
gpasswd -a $MYUSER autologin
echo "
[Seat:*]
greeter-hide-users=true
user-session=i3
greeter-setup-script=/usr/bin/numlockx on
autologin-user=$MYUSER" >> /etc/lightdm/lightdm.conf
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# GRUB
echo -e "        ${RED} # Hide the grub menu (quick start and better security) ${COLOR_OFF}"
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# create my own folders
echo -e "        ${RED} # Delete the old folder structure in home and create a better one (mine) ${COLOR_OFF}"
cd /home/$MYUSER/
rmdir *
for myfolder in "
Files
Downloads
Transferts
Medias
Unclear"
do
  sudo -u $MYUSER mkdir /home/$MYUSER/$myfolder
done
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

######################### END

# banner and time
echo
echo -e "        ${RED} ########################################## ${COLOR_OFF}"
echo -e "        ${RED} # Centos fast install complete             ${COLOR_OFF}"
echo -e "        ${RED} ########################################## ${COLOR_OFF}"
echo
echo "end at $(date +\%F\ \%H:%M)"
echo
echo "${RED} Please reboot and check ${COLOR_OFF}"
echo