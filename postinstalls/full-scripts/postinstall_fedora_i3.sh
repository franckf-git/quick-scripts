#! /bin/bash
#
# first install fedora minimal, then
# wget https://framagit.org/efydd/config/raw/master/.postinstall/fedora_i3.sh
# add --full has argument for full install

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

# install and config of the firewall
echo -e "        ${RED} # Set the firewall to drop all input (open only if needed) ${COLOR_OFF}"
systemctl start firewalld
systemctl enable firewalld
systemctl disable sshd
firewall-cmd --set-default-zone=drop
firewall-cmd --complete-reload
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# install graphical environnement, install the i3 windows manager and set graphical
###############TRY TO REDUCE
echo -e "        ${RED} # Install the i3 windows manager ${COLOR_OFF}"
dnf groupinstall base-x
dnf install lightdm xorg-x11-xinit-session initial-setup-gui xvattr xorg-x11-drivers i3 i3status dejavu-sans-mono-fonts
systemctl set-default graphical.target
sudo systemctl enable lightdm
swapon
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# install my softwares
echo -e "        ${RED} # Install only the packages you need ${COLOR_OFF}"
myprogram="
bleachbit
encfs
feh
firefox
fontawesome-fonts
iwl*-firmware
network-manager-applet
prename
pulseaudio
ranger
rxvt-unicode
unclutter
vim-X11
xfce4-power-manager"
dnf install -y $myprogram
dnf upgrade --refresh -y
dnf clean packages -y
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

# rules for dnf
echo -e "        ${RED} # Set dnf deltarpm (for slow connections) and two kernel to keep ${COLOR_OFF}"
echo "[main]
gpgcheck=1
installonly_limit=2
clean_requirements_on_remove=true
fastestmirror=true" > /etc/dnf/dnf.conf
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# create my own folders
echo -e "        ${RED} # Delete the old folder structure in home and create a better one (mine) ${COLOR_OFF}"
cd /home/$MYUSER/
rmdir *
for myfolder in "
Downloads
Transferts
Medias"
do
  sudo -u $MYUSER mkdir /home/$MYUSER/$myfolder
done
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

######################### END

# if you use the script in full mode
if [ "$1" = "--full" ]
  then
    # fusion repository
    echo -e "        ${RED} # Add the fusion repositories (more package and deal with some codecs) ${COLOR_OFF}"
    dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)"
    rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)"
    dnf check-update
    echo -e "[${RED} DONE ${COLOR_OFF}]"
    echo

    # full install my softwares
    echo -e "        ${RED} # Install the other packages ${COLOR_OFF}"
    myprogram="
    breeze-cursor-theme
    chkrootkit
    chromium
    chromium-libs-media-freeworld
    conky
    evince
    gedit
    gedit-plugins
    git
    htop
    i3
    i3lock
    keepassxc
    lxappearance
    lynis
    numlockx
    mpv
    pop-icon-theme
    rkhunter
    scrot
    xarchiver
    xbacklight
    youtube-dl"
    dnf install -y $myprogram
    dnf upgrade --refresh -y
    dnf clean packages -y
    echo -e "[${RED} DONE ${COLOR_OFF}]"
    echo

    # create my own folders
    echo -e "        ${RED} # Add missing folders ${COLOR_OFF}"
    cd /home/$MYUSER/
    for myfolder in "
    Files
    Unclear"
    do
      sudo -u $MYUSER mkdir /home/$MYUSER/$myfolder
    done
    echo -e "[${RED} DONE ${COLOR_OFF}]"
    echo
fi

# banner and time
echo
echo -e "        ${RED} ########################################## ${COLOR_OFF}"
echo -e "        ${RED} # Fedora fast install complete             ${COLOR_OFF}"
echo -e "        ${RED} ########################################## ${COLOR_OFF}"
echo
echo "end at $(date +\%F\ \%H:%M)"
echo
echo "${RED} Please reboot and check ${COLOR_OFF}"
echo