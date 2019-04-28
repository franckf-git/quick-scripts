#! /bin/bash
#
# postintall script for debian system with flatpak
# wget https://framagit.org/efydd/quick_scripts/raw/master/postinstall_debian_system.sh
# install debian from net-install cd

######################### VARIABLES

# colors
RED="\033[1;31m"
GREEN="\033[1;32m"
COLOR_OFF="\033[0m"
# define the main user
MYUSER=$(cat /etc/passwd | grep home | cut -d ":" -f 1)

######################### PERMISSIONS

# use it at root
if [ $EUID -ne 0 ] ; then
    echo "################################################################"
    echo -e "${RED}/""!""\\"" ${COLOR_OFF} You must be root to play the script. Please try again.  ""${RED}/""!""\\"" ${COLOR_OFF}"
    echo "################################################################"
    exit 1
fi

######################### OPTIONS

# use it with arguments or nothing
if [ -z "$1" ]  || [ "$1" = "--help" ] ; then
    echo "################################################################"
    echo -e "${RED}/""!""\\"" ${COLOR_OFF}                You must add an argument                 ""${RED}/""!""\\"" ${COLOR_OFF}"
    echo "################################################################"
    echo "# You can use it with :                                        #"
    echo "# --debian : for a install on debian system                    #"
    echo "################################################################"
    exit 1
fi

######################### START

clear

# banner and time
echo
echo -e "        ${GREEN} ########################################## ${COLOR_OFF}"
echo -e "        ${GREEN} # Debian fast install (less than an hour)  ${COLOR_OFF}"
echo -e "        ${GREEN} ########################################## ${COLOR_OFF}"
echo
echo "start at $(date +\%F\ \%H:%M)"
echo

#allow sudo to user
echo -e "        ${GREEN} # Allow sudo to the basic user ${COLOR_OFF}"
apt-get update --assume-yes
apt install --assume-yes sudo
adduser $MYUSER sudo
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# install and config of the firewall
echo -e "        ${GREEN} # Set the firewall to drop all input (open only if needed) ${COLOR_OFF}"
apt install --assume-yes ufw
sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw
ufw enable
ufw default deny incoming
ufw default deny outgoing
ufw allow out 80/tcp
ufw allow out 443/tcp
ufw allow out 53/udp
systemctl disable sshd
systemctl stop sshd
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### REPOS

echo -e "        ${GREEN} # Add some repositories (non-free and backport) ${COLOR_OFF}"
echo "
# Debian stretch main and non-free repository
deb http://ftp.fr.debian.org/debian/ stretch main contrib non-free

# Debian stretch security repository
deb http://security.debian.org/debian-security/ stretch/updates main contrib non-free

# Debian stretch update repository
deb http://ftp.fr.debian.org/debian/ stretch-updates main contrib non-free

# Backports repository
deb http://ftp.fr.debian.org/debian/ stretch-backports main contrib non-free
" > /etc/apt/sources.list
apt-get update --assume-yes
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### SOFTS

# install my softwares
echo -e "        ${GREEN} # Install only the packages you need ${COLOR_OFF}"
myprogram="
bash-completion
bc
bleachbit
bzip2
chkrootkit
chromium
conky
debsums 
dunst
encfs
feh
firefox-esr
firmware-iwlwifi
flatpak
fonts-font-awesome
git
htop
i3
i3lock
i3status
lightdm
less
lynis
man
mpv
mupdf
neovim
network-manager
numlockx
pulseaudio
pulseaudio-utils
ranger
ristretto
rkhunter
rofi
rsync
rxvt-unicode
scrot
tar
udisks2
ufw
unclutter
unzip
wget
xfce4-power-manager
youtube-dl"
#network-manager-gnome"
apt install --assume-yes $myprogram
apt-get dist-upgrade --assume-yes
apt autoremove --assume-yes
apt autoclean --assume-yes
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# install my softwares with flatpak
echo -e "        ${GREEN} # Install the flatpak repo and the flatpak you need ${COLOR_OFF}"
myflatpak="
com.sublimetext.three
org.gnome.Calculator"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --assumeyes flathub $myflatpak
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### OPTIMIZE

# config for SSD
echo -e "        ${GREEN} # Configuration of mount point for SSD (better performance) ${COLOR_OFF}"
sed --in-place='s/defaults/defaults,discard/g' /etc/fstab
sed --in-place='s/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf
echo noop | tee /sys/block/sda/queue/scheduler
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# autologin (only for encrypt HDD)
echo -e "        ${GREEN} # If you use an encrypt HDD, you can autologin to lightdm ${COLOR_OFF}"
groupadd --system autologin --gid 1001
gpasswd --add $MYUSER autologin
echo "
[Seat:*]
greeter-hide-users=true
user-session=i3
greeter-setup-script=/usr/bin/numlockx on
autologin-user=$MYUSER" >> /etc/lightdm/lightdm.conf
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# GRUB
echo -e "        ${GREEN} # Hide the grub menu (quick start and better security) ${COLOR_OFF}"
sed --in-place='s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=3/g' /etc/default/grub
rm /usr/share/images/desktop-base/desktop-grub.png
update-grub
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### CONFIG

# config for touchpad
echo -e "        ${GREEN} # If you are on a laptop uncomment this part for touchpad ${COLOR_OFF}"
# apt install libnotify-bin
# echo "
# Section "InputClass"
#         Identifier "libinput touchpad catchall"
#         MatchIsTouchpad "on"
#         MatchDevicePath "/dev/input/event*"
#         Driver "libinput"
#         Option "Tapping" "on"
# EndSection" >> /etc/X11/xorg.conf.d/40-libinput.conf
# echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# create my own folders
echo -e "        ${GREEN} # Delete the old folder structure in home and create a better one (mine) ${COLOR_OFF}"
cd /home/$MYUSER/
rmdir *
for myfolder in "
Files
Downloads
Transferts
Medias
Unclear"
do
  sudo --user=$MYUSER mkdir /home/$MYUSER/$myfolder
done
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# set my own config dot files
echo -e "        ${GREEN} # Download my config files from gitlab and put them on ${COLOR_OFF}"
sudo --user=$MYUSER ranger --copy-config=all
cd /home/$MYUSER/Downloads
sudo --user=$MYUSER wget https://framagit.org/efydd/config/-/archive/master/config-master.tar
sudo --user=$MYUSER tar xvf config-master.tar
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# setup crontab
echo -e "        ${GREEN} # Add a crontab to check for security every sunday morning ${COLOR_OFF}"
crontab < <(crontab -l ; echo "00 07 * * 0 /home/$MYUSER/.sec/sec.sh")
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# setup audio
echo -e "        ${GREEN} # Configure PulseAudio with starting deamon ${COLOR_OFF}"
sudo --user=$MYUSER pulseaudio --kill
sudo --user=$MYUSER pulseaudio -D
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### END

# banner and time
echo
echo -e "        ${GREEN} ########################################## ${COLOR_OFF}"
echo -e "        ${GREEN} # Debian fast install complete      ${COLOR_OFF}"
echo -e "        ${GREEN} ########################################## ${COLOR_OFF}"
echo
echo "end at $(date +\%F\ \%H:%M)"
echo
echo -e "${RED} Please reboot and check ${COLOR_OFF}"
echo
