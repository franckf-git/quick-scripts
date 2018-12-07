#! /bin/bash
# use at root

MYUSER=$(grep bash /etc/passwd | grep -v root | cut -d ":" -f 1)

clear

#repository of the current version
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

#allow sudo to user
apt-get update -y
apt install -y sudo
adduser $MYUSER sudo

#install and config of the firewall
apt-get dist-upgrade -y
apt install -y ufw
sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw
ufw enable
ufw default deny incoming
ufw default deny outgoing
ufw allow out 80/tcp
ufw allow out 443/tcp
ufw allow out 53/udp
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

#autologin, only for encrypt HDD
echo "
greeter-hide-users=true
greeter-setup-script=/usr/bin/numlockx on
autologin-user=$MYUSER" >> /etc/lightdm/lightdm.conf

#no wait for GRUB
echo "
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="" " > /etc/default/grub
update-grub

#install my softwares
apt update -y
myprogram="
aptitude
bash-completion
bleachbit
chkrootkit
chromium
chromium-l10n
clamav
clamtk
conky
cryptsetup
curl
debsums
dnsutils
eog
encfs
exfat-fuse
exfat-utils
ffmpeg
firejail
firmware-iwlwifi
galculator
gimp
git
gparted
handbrake
htop
idle-python3.5
inkscape
intel-microcode
inxi
jp2a
keepassx
libdvdcss2
libdvdread4
libmatroska6v5
libreoffice
libreoffice-help-fr
lightdm
locate
lynis
ntfs-3g
numlockx
rkhunter
rsync
screenfetch
synaptic
tcpdump
tree
vlc
youtube-dl"
apt install -y $myprogram
apt-get upgrade -y
apt autoremove -y && apt autoclean -y

#install virtualbox
echo "
# Virtualbox repository
deb http://download.virtualbox.org/virtualbox/debian stretch contrib" >> /etc/apt/sources.list
wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
apt-key add oracle_vbox_2016.asc
apt-get update
apt-get install -y virtualbox-5.1
rm oracle_vbox_2016.asc

#install wine
dpkg --add-architecture i386
apt update
apt install -y wine32

#install sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
apt-get update
apt-get install sublime-text

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
crontab < <(crontab -l ; echo "00 20 * * * apt update")
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
alias upg='sudo apt update && sudo apt -V upgrade && sudo apt-get autoremove -y && sudo apt-get clean'
alias csv='column -s ',' -t'
alias git_log='git log --pretty'
alias bup='rsync -avh --delete-before --stats --ignore-errors --exclude={"Medias/","Transferts/"} /home/$MYUSER /media/$MYUSER/SAV/'
alias radio='mpv --vid=no https://www.youtube.com/watch?v=AQBh9soLSkI'
" >> /home/$MYUSER/.bashrc

apt-get autoremove -y
apt-get clean
echo "---------------END---------------"
#reboot