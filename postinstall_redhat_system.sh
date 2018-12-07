#! /bin/bash
#
# postintall script for redhat system with flatpak
# wget https://framagit.org/efydd/config/raw/master/.postinstall/redhat_system_postintall.sh

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
    echo "# --centos : for a install on centos system                    #"
    echo "# --full : for a full install on fedora system with more apps  #"
    echo "# --minimal : for a mininal install on fedora system           #"
    echo "# --work : only in second argument for a work machine          #"
    echo "################################################################"
    exit 1
fi

######################### START

clear

# banner and time
echo
echo -e "        ${GREEN} ################################################# ${COLOR_OFF}"
echo -e "        ${GREEN} # Fedora/Centos fast install (less than an hour)  ${COLOR_OFF}"
echo -e "        ${GREEN} ################################################# ${COLOR_OFF}"
echo
echo "start at $(date +\%F\ \%H:%M)"
echo

# install and config of the firewall
echo -e "        ${GREEN} # Set the firewall to drop all input (open only if needed) ${COLOR_OFF}"
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=drop
firewall-cmd --complete-reload
systemctl disable sshd
systemctl stop sshd
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### REPOS

# epel repository for centos and fusion repository for fedora full mode
case $1 in
"--centos" )
    echo -e "        ${GREEN} # Add the epel repositories (must have for a desktop application) ${COLOR_OFF}"
    yum -y install epel-release
    #yum-config-manager --enable extras #if yum-utils
    yum check-update
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
;;
"--full" )
    echo -e "        ${GREEN} # Add the fusion repositories (more package and deal with some codecs) ${COLOR_OFF}"
    dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)"
    rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)"
    dnf check-update
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
;;
"--minimal")
    echo
    echo -e "        ${GREEN} # No extras repo in minimal mode ${COLOR_OFF}"
    echo
;;
esac

######################### GUI

# install graphical environnement install the i3 windows manager and set graphical
######################### TRY TO REDUCE
echo -e "        ${GREEN} # Install the i3 windows manager ${COLOR_OFF}"

if [ "$1" = "--centos" ] ; then
    yum -y groupinstall "X Window System"
    yum -y install lightdm xorg-x11-xinit-session dejavu-sans-mono-fonts i3 i3status
else
    dnf -y groupinstall base-x
    dnf -y install lightdm xorg-x11-xinit-session dejavu-sans-mono-fonts i3 i3status initial-setup-gui xvattr xorg-x11-drivers
fi
systemctl set-default graphical.target
systemctl enable lightdm
swapon
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### SOFTS

# install my softwares
echo -e "        ${GREEN} # Install only the packages you need ${COLOR_OFF}"
case $1 in
"--centos" )
myprogram="
bash-completion
bleachbit
chromium
conky
encfs
firefox
flatpak
fontawesome-fonts
git
htop
i3lock
iwl*-firmware
lynis
network-manager-applet
prename
pulseaudio
pulseaudio-utils
ristretto
rsync
rkhunter
rxvt-unicode
tar
udisks2
unzip
neovim
xfce4-power-manager
xfce4-notifyd
youtube-dl
wget"
;;
"--minimal" )
myprogram="
bash-completion
bleachbit
encfs
feh
firefox
flatpak
fontawesome-fonts
iwl*-firmware
network-manager-applet
prename
pulseaudio
pulseaudio-utils
ranger
ristretto
rsync
rxvt-unicode
tar
udisks2
unclutter
unzip
neovim
xfce4-power-manager
wget"
;;
"--full")
myprogram="
bash-completion
bleachbit
breeze-cursor-theme
chkrootkit
chromium
chromium-libs-media-freeworld
conky
encfs
feh
firefox
flatpak
fontawesome-fonts
git
htop
i3lock
iwl*-firmware
keepassxc
lynis
mpv
network-manager-applet
numlockx
pop-icon-theme
prename
pulseaudio
pulseaudio-utils
ranger
ristretto
rkhunter
rsync
rxvt-unicode
scrot
tar
udisks2
unclutter
unzip
neovim
xfce4-power-manager
xfce4-notifyd
youtube-dl
wget"
;;
esac
yum install -y --skip-broken $myprogram
yum upgrade -y
yum clean packages -y
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# install ranger in centos
if [ "$1" = "--centos" ] ; then
    echo -e "        ${GREEN} # Install ranger from sources because not in the repos ${COLOR_OFF}"
    cd /home/$MYUSER
    wget https://ranger.github.io/ranger-stable.tar.gz
    tar xvf ranger-stable.tar.gz
    cd ranger-*
    make install
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
fi

# install my softwares with flatpak
echo -e "        ${GREEN} # Install only the flatpak you need ${COLOR_OFF}"
case $1 in
"--centos" )
myflatpak="
io.github.GnomeMpv"
;;
"--minimal")
myflatpak="
net.baseart.Glide"
;;
"--full")
myflatpak="
com.sublimetext.three
fr.handbrake.ghb
io.atom.Atom
org.gimp.GIMP
org.gnome.Calculator
org.gnome.Evince
org.gnome.PasswordSafe
org.libreoffice.LibreOffice"
;;
esac
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --assumeyes flathub $myflatpak
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# install packages for work
if [ "$2" = "--work" ] ; then
    echo -e "        ${GREEN} # Install only the flatpak for the work machine ${COLOR_OFF}"
    for flatpakwork in "
    com.jgraph.drawio.desktop
    org.fedoraproject.MediaWriter
    org.gajim.Gajim
    org.gnome.Evolution
    org.gnome.Geary
    org.keepassxc.KeePassXC
    org.nextcloud.Nextcloud"
    do
      flatpak install --assumeyes flathub $flatpakwork
    done
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
fi

######################### OPTIMIZE

# config for SSD
echo -e "        ${GREEN} # Configuration of mount point for SSD (better performance) ${COLOR_OFF}"
sed -i 's/defaults/defaults,discard/g' /etc/fstab
sed -i 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf
echo noop | tee /sys/block/sda/queue/scheduler
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# autologin (only for encrypt HDD)
echo -e "        ${GREEN} # If you use an encrypt HDD, you can autologin to lightdm ${COLOR_OFF}"
groupadd -r autologin -g 1001
gpasswd -a $MYUSER autologin
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
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# rules for dnf on fedora
if [ "$1" != "--centos" ] ; then
    echo -e "        ${GREEN} # Set dnf deltarpm (for slow connections) and two kernel to keep ${COLOR_OFF}"
    echo "[main]
gpgcheck=1
installonly_limit=2
clean_requirements_on_remove=true
fastestmirror=true" > /etc/dnf/dnf.conf
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
fi

######################### CONFIG

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
  sudo -u $MYUSER mkdir /home/$MYUSER/$myfolder
done
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# set my own config dot files
echo -e "        ${GREEN} # Download my config files from gitlab and put them on ${COLOR_OFF}"
sudo -u $MYUSER ranger --copy-config=all
cd /home/$MYUSER/Downloads
sudo -u $MYUSER wget https://framagit.org/efydd/config/-/archive/master/config-master.tar
sudo -u $MYUSER tar xvf config-master.tar
sudo -u $MYUSER cd config-master
for dotfile in "
.bash.command-not-found
.bash_profile
.bashrc
.cheat/
.conky/
.gitconfig
.mpv/
.nano/
.nanorc
.nav/
.postinstall/
.programs/
.rtfm/
.sec/
.themes/
.tldr/
.vimrc
.Xdefaults"
do
sudo -u $MYUSER mv $dotfile /home/$MYUSER/
done
sudo -u $MYUSER mv .config/* /home/$MYUSER/.config/
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# setup crontab
echo -e "        ${GREEN} # Add a crontab to check for security every sunday morning ${COLOR_OFF}"
crontab < <(crontab -l ; echo "00 07 * * 0 /home/$MYUSER/.sec/sec.sh")
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### END

# banner and time
echo
echo -e "        ${GREEN} ########################################## ${COLOR_OFF}"
echo -e "        ${GREEN} # Fedora/Centos fast install complete      ${COLOR_OFF}"
echo -e "        ${GREEN} ########################################## ${COLOR_OFF}"
echo
echo "end at $(date +\%F\ \%H:%M)"
echo
echo -e "${RED} Please reboot and check ${COLOR_OFF}"
echo
