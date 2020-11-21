#! /bin/bash
# use at root

MYUSER=$(grep bash /etc/passwd | grep -v root | cut -d ":" -f 1)

clear

#fusion repository
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-27"
rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-27"

#allow sudo to user
dnf check-update -y
dnf upgrade -y
dnf install -y sudo
useradd -G wheel $MYUSER
groupadd -r autologin
gpasswd -a $MYUSER autologin

#install and config of the firewall
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=drop
firewall-cmd --list-interfaces
firewall-cmd --get-active-zone
firewall-cmd --complete-reload
systemctl disable exim4.service
systemctl disable rpcbind.service
systemctl disable rpcbind.socket

#config for SSD
sed -i 's/defaults/defaults,discard/g' /etc/fstab
sed -i 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf
echo noop | tee /sys/block/sda/queue/scheduler

#laptop mode
echo "
vm.laptop_mode = 5 " >> /etc/sysctl.conf

#lower swap level
echo "
vm.swappiness = 10 " >> /etc/sysctl.conf

#secure shm
echo "
tmpfs /dev/shm tmpfs  defaults,noatime,nosuid,noexec,nodev   0 0" >> /etc/fstab
mount /dev/shm

#autologin, only for encrypt HDD, watch VNC server
echo "
[SeatDefaults]
#...
pam-service=lightdm
pam-autologin-service=lightdm-autologin
autologin-user=$MYUSER
autologin-user-timeout=0
session-wrapper=/etc/lightdm/Xsession
greeter-hide-users=true
greeter-setup-script=/usr/bin/numlockx on" >> /etc/lightdm/lightdm.conf

#install my softwares
dnf update -y
myprogram="
bash-completion
bleachbit
chkrootkit
chromium
chromium-libs-media-freeworld
clamav
clamtk
conky
cryptsetup
curl
bind-utils
eog
encfs
exfat-utils
ffmpeg
iwl6000g2b
galculator
gimp
git
gparted
handbrake-gui
htop
inkscape
inxi
jp2a
keepassx
libreoffice
libreoffice-help-fr
lightdm-settings
lynis
ntfs-3g
numlockx
rkhunter
rsync
screenfetch
tcpdump
tree
virtualbox
wine
vlc
youtube-dl"
dnf install -y $myprogram
dnf clean packages -y

#install firejail
wget https://sourceforge.net/projects/firejail/files/firejail/firejail-0.9.50-1.x86_64.rpm
rpm -i firejail-0.9.50-1.x86_64.rpm

#rip dvd
dnf config-manager --add-repo=https://negativo17.org/repos/fedora-multimedia.repo
dnf -y install HandBrake-gui HandBrake-cli

#play dvd
dnf config-manager --add-repo=https://negativo17.org/repos/fedora-multimedia.repo
dnf -y install libdvdcss libdvdread libdvdnav

#install sublime
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf install -y sublime-text

#create my own folders
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

#my own config files
sudo -u $MYUSER tar -xjf install_folder.tar.bz2 install_folder

sudo -u $MYUSER mv install_folder/.conky /home/$MYUSER
sudo -u $MYUSER mv install_folder/.icons /home/$MYUSER
sudo -u $MYUSER cp -r install_folder/xfce4/ /home/$MYUSER/.config/xfce4/

#backup script
#! /bin/bash
#mkdir /home/$USER/install_folder
#
#for myconfig in '.conky
#.icons
#.config/xfce4'
#do
#  cp -R /home/$USER/$myconfig /home/$USER/install_folder
#done
#
#tar -cvjf install_folder.tar.bz2 install_folder
#
#rm -R /home/$USER/install_folder
###
#in install_folder
#.conky/
#+-- conkyrcLaptop
#+-- conkyrcLog
#+-- conkystart.sh
#
#.icons/
#+-- capitaine-cursors
#+-- ePapirus
#+-- Papirus
#+-- Papirus-Dark
#+-- Papirus-Light
#+-- Ultra-Flat-Numix
#
#.config/xfce4
#+-- helpers.rc
#+-- help.rc
#+-- panel
#+-- terminal
#+-- xfce4-notes.gtkrc
#+-- xfce4-screenshooter
#+-- xfconf
#+-- xfwm4

rm -R install_folder.tar.bz2 install_folder

#setup crontab
sudo -u $MYUSER crontab < <(crontab -l ; echo "@reboot /home/$MYUSER/.conky/conkystart.sh")
crontab < <(crontab -l ; echo "00 20 * * * dnf check-update")
crontab < <(crontab -l ; echo "00 07 * * 0 /home/$MYUSER/.sec/sec.sh")

#personnal commands to fix !!!
echo "
# personnal commands
PS1="\[\e[1;31m\]> | \A | \W | \\$\[\e[m\] "

mkcd() {
    mkdir -p "$1" ; cd -P "$1"
}

got () {
  if [ -z "$1" ]
then
  echo "Usage: got file message"
else
  git add $1 && git commit -m "$*"
fi
}

#command_not_found_handle () {
#    echo "Hello Stupid ¯\_(ツ)_/¯ !";
#}
if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

alias 4chan='wget -nd -H -p -A .jpg,.jpeg,.png,.gif,.webm -rc -D i.4cdn.org -P 4chan -e robots=off'
alias ll='ls -lasFh --color=auto'
alias ls='ls --color=auto'
alias meteo='wget wttr.in -O - -o /dev/null'
alias upg='sudo dnf check-update ; sudo dnf upgrade -y ; sudo dnf clean packages -y'
alias csv='column -s ',' -t'
alias git_log='git log --pretty'
alias bup='rsync -avh --delete-before --stats --ignore-errors --exclude={"Medias/","Transferts/"} /home/$MYUSER /media/$MYUSER/SAV/'
alias radio='mpv --vid=no https://www.youtube.com/watch?v=AQBh9soLSkI'
" >> /home/$MYUSER/.bashrc

apt-get autoremove -y
apt-get clean
echo "---------------END---------------"
#reboot