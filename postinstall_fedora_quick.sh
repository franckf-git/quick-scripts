#! /bin/bash
#
# first install fedora xfce minimal, then
# wget https://framagit.org/efydd/config/raw/master/.postinstall/postinstall_fedora_quick.sh

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

# fusion repository
echo -e "        ${RED} # Add the fusion repositories (more package and deal with some codecs) ${COLOR_OFF}"
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)"
rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)"
dnf check-update
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# install and config of the firewall
echo -e "        ${RED} # Set the firewall to drop all input (open only if needed) ${COLOR_OFF}"
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=drop
firewall-cmd --complete-reload
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
fastestmirror=true
deltarpm=1" > /etc/dnf/dnf.conf
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# install my softwares
echo -e "        ${RED} # Install only the packages you need ${COLOR_OFF}"
myprogram="
bleachbit
breeze-cursor-theme
chkrootkit
chromium
chromium-libs-media-freeworld
conky
encfs
evince
feh
ffmpeg
fontawesome-fonts
GConf2
gedit
gedit-plugins
git
htop
i3
i3lock
inxi
keepassxc
lxappearance
lynis
numlockx
mpv
pop-icon-theme
prename
ranger
ristretto
rkhunter
rxvt-unicode
scrot
unclutter
xarchiver
xbacklight
youtube-dl"
dnf install -y $myprogram
dnf upgrade --refresh -y
dnf clean packages -y
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

# install sublime
echo -e "        ${RED} # Install sublime text repos and package (but gedit do the job) ${COLOR_OFF}"
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf install -y sublime-text
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

# clear useless services
systemctl disable sshd
systemctl disable cups
systemctl disable bluetooth
systemctl disable qemu-guest-agent
systemctl disable vboxservice
systemctl disable nfs-client

# setup crontab
echo -e "        ${RED} # Add a crontab to check for security every sunday morning ${COLOR_OFF}"
crontab < <(crontab -l ; echo "00 07 * * 0 /home/$MYUSER/.sec/sec.sh")
echo -e "[${RED} DONE ${COLOR_OFF}]"
echo

######################### END

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