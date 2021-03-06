#! /bin/bash
#
# postintall script for redhat system with flatpak
# wget https://framagit.org/efydd/quick_scripts/raw/master/postinstall_redhat_system.sh
# install centos or fedora from minimal cd
# for centos use source https://mirror.CentOS.org/CentOS/7.5.1804/os/x86_64/
# and dont check use "This URL refers to a mirror list"

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
# zone par defaut
firewall-cmd --set-default-zone=drop
# efface les anciennes règles
firewall-cmd --direct --permanent --remove-rules ipv4 filter INPUT
firewall-cmd --direct --permanent --remove-rules ipv4 filter OUTPUT
# verrouiller le parefeu a certaines applications root
firewall-cmd --lockdown-on
# pas d entrée - pas de sortie
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT  0 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 1 -j DROP
# règle de sortie supérieurs au drop
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -p tcp -m tcp --dport 22  -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -p tcp -m tcp --dport 80  -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -p tcp -m tcp --dport 443 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -p tcp -m tcp --dport 53  -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -p udp -m udp --dport 53  -j ACCEPT
# pas de ping
firewall-cmd --zone=public --permanent --add-icmp-block=destination-unreachable
# rechargement
firewall-cmd --reload
firewall-cmd --complete-reload
# vérification des règles
firewall-cmd --permanent --direct --get-all-rules
firewall-cmd --direct --get-all-rules
firewall-cmd --list-all
systemctl disable sshd
systemctl stop sshd
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# config of selinux
echo -e "        ${GREEN} # Set selinux to enforce ${COLOR_OFF}"
sed -i 's/SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
systemctl restart selinux-basics.service
sestatus
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# rules for dnf on fedora
if [ "$1" != "--centos" ] ; then
    echo -e "        ${GREEN} # Set dnf deltarpm (for slow connections), no weak dependencies (only requires) and 3 kernels to keep ${COLOR_OFF}"
    echo "[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=true
install_weak_deps=false
fastestmirror=true" > /etc/dnf/dnf.conf
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
fi

######################### REPOS

# epel repository for centos and fusion repository for fedora full mode
case $1 in
"--centos" )
    echo -e "        ${GREEN} # Add the epel repositories (must have for a desktop application) ${COLOR_OFF}"
    yum --assumeyes install epel-release
    yum-config-manager --enable extras
    subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"
    yum check-update
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
;;
"--full" )
    echo -e "        ${GREEN} # Add the fusion repositories (more package and deal with some codecs) ${COLOR_OFF}"
    dnf install --assumeyes https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    dnf install --assumeyes https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
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
    yum --assumeyes groupinstall "X Window System"
    yum --assumeyes install lightdm xorg-x11-xinit-session levien-inconsolata-fonts i3 i3status
else
    dnf --assumeyes groupinstall base-x
    dnf --assumeyes install lightdm xorg-x11-xinit-session levien-inconsolata-fonts i3 i3status initial-setup-gui xvattr xorg-x11-drivers
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
rofi                            # desktop-applications-launch
fontawesome-fonts               # desktop-icons
i3lock                          # desktop-locker
conky                           # desktop-display-info
dunst                           # desktop-display-notify
scrot                           # desktop-screenshot
udisks2                         # desktop-usb-mount
unclutter                       # desktop-mouse
encfs                           # security-folder
chkrootkit                      # security-rootkit
lynis                           # security-analyser
rkhunter                        # security-rootkit
bleachbit                       # system-clean
flatpak                         # system-applications
git                             # system-versionning
htop                            # system-monitor
xfce4-power-manager             # system-configuration-power
network-manager-applet          # system-configuration-network
numlockx                        # system-numpad
pulseaudio                      # system-audio
pulseaudio-utils                # system-audio-configuration
rsync                           # system-copy
surf                            # web-browser-light
chromium                        # web-browser
firefox                         # web-browser-secure
newsboat                        # terminal-news-feed
feh                             # image-viewer-light ghettoforge ?
iwl*-firmware                   # hardware-wifi-driver
mpv                             # video-audio-player
mupdf                           # pdf-viewer-light
neovim                          # editor-light
ranger                          # file-explorer-light
rxvt-unicode                    # terminal-light
bash-completion                 # terminal-help
prename                         # terminal-utilities
tar                             # terminal-utilities
bzip2                           # terminal-utilities
unzip                           # terminal-utilities
youtube-dl                      # terminal-utilities
wget                            # terminal-utilities
xfce4-terminal                  # terminal
powerline-fonts                 # terminal-font
zsh                             # terminal-display
"
;;
"--minimal" )
myprogram="
rofi                            # desktop-applications-launch
fontawesome-fonts               # desktop-icons
dunst                           # desktop-display-notify
scrot                           # desktop-screenshot
udisks2                         # desktop-usb-mount
unclutter                       # desktop-mouse
bleachbit                       # system-clean
flatpak                         # system-applications
htop                            # system-monitor
xfce4-power-manager             # system-configuration-power
network-manager-applet          # system-configuration-network
pulseaudio                      # system-audio
pulseaudio-utils                # system-audio-configuration
rsync                           # system-copy
surf                            # web-browser-light
firefox                         # web-browser-secure
newsboat                        # terminal-news-feed
feh                             # image-viewer-light
iwl*-firmware                   # hardware-wifi-driver
mupdf                           # pdf-viewer-light
neovim                          # editor-light
ranger                          # file-explorer-light
rxvt-unicode                    # terminal-light
bash-completion                 # terminal-help
prename                         # terminal-utilities
tar                             # terminal-utilities
bzip2                           # terminal-utilities
unzip                           # terminal-utilities
youtube-dl                      # terminal-utilities
wget                            # terminal-utilities
"
;;
"--full")
myprogram="
rofi                            # desktop-applications-launch
fontawesome-fonts               # desktop-icons
i3lock                          # desktop-locker
python3-pillow                  # python for blur lock
conky                           # desktop-display-info
dunst                           # desktop-display-notify
scrot                           # desktop-screenshot
udisks2                         # desktop-usb-mount
unclutter                       # desktop-mouse
encfs                           # security-folder
chkrootkit                      # security-rootkit
lynis                           # security-analyser
rkhunter                        # security-rootkit
bleachbit                       # system-clean
flatpak                         # system-applications
git                             # system-versionning
htop                            # system-monitor
numlockx                        # system-numpad
pulseaudio                      # system-audio
pulseaudio-utils                # system-audio-configuration
rsync                           # system-copy
surf                            # web-browser-light
chromium                        # web-browser
w3m-img                         # web-browser-secure
newsboat                        # terminal-news-feed
feh                             # image-viewer-light
iwl*-firmware                   # hardware-wifi-driver       #optionnal
mpv                             # video-audio-player
mupdf                           # pdf-viewer-light
neovim                          # editor-light
ranger                          # file-explorer-light
rxvt-unicode                    # terminal-light
bash-completion                 # terminal-help
prename                         # terminal-utilities
tar                             # terminal-utilities
bzip2                           # terminal-utilities
unzip                           # terminal-utilities
youtube-dl                      # terminal-utilities
wget                            # terminal-utilities
xfce4-terminal                  # terminal
powerline-fonts                 # terminal-font
zsh                             # terminal-display
"
;;
esac
yum install --assumeyes --skip-broken $myprogram
yum upgrade --assumeyes
yum clean packages --assumeyes
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
    cd /home/$MYUSER
    rm -R ranger-*
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
fi

# centos cleaning services
if [ "$1" = "--centos" ] ; then
    echo -e "        ${GREEN} # Clean useless services ${COLOR_OFF}"
    systemctl disable spice-vdagentd
    systemctl disable rtkit-daemon
    systemctl disable postfix
    yum remove spice-vdagent
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
fi

# install my softwares with flatpak
echo -e "        ${GREEN} # Install only the flatpak you need ${COLOR_OFF}"
case $1 in
"--centos" )
myflatpak="
"
;;
"--minimal")
myflatpak="
"
;;
"--full")
myflatpak="
com.sublimetext.three             # editor
org.gnome.Calculator              # desktop-caculator
org.gnome.Evince                  # pdf-viewer
org.gnome.PasswordSafe            # security-passwords
fr.handbrake.ghb                  # encode
flathub com.makemkv.MakeMKV       # encode
org.mozilla.FirefoxDevEdition     # dev firefox
freedesktop.Platform.ffmpeg       # audio support
"
;;
esac
flatpak remote-add --from org.mozilla.FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --assumeyes $myflatpak
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# install packages for work
if [ "$2" = "--work" ] ; then
    echo -e "        ${GREEN} # Install only the flatpak for the work machine ${COLOR_OFF}"
    for flatpakwork in "
    com.mattermost.Desktop            # communications
    org.audacityteam.Audacity         # audio-editor
    com.jgraph.drawio.desktop         # schematics-editor
    org.gimp.GIMP                     # image-editor
    org.libreoffice.LibreOffice       # editor-full
    org.filezillaproject.Filezilla    # file-transfert
    org.keepassxc.KeePassXC           # security-passwords
    org.nextcloud.Nextcloud           # desktop-sync-client
    org.fedoraproject.MediaWriter     # system-iso-writer
    "
    do
      flatpak install --assumeyes flathub $flatpakwork
    done
    echo -e "[${GREEN} DONE ${COLOR_OFF}]"
    echo
fi

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
grub2-mkconfig --output=/boot/grub2/grub.cfg
grub2-mkconfig --output=/boot/efi/EFI/fedora/grub.cfg
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

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
  sudo --user=$MYUSER mkdir /home/$MYUSER/$myfolder
done
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# set my own config dot files
echo -e "        ${GREEN} # Download my config files from gitlab and put them on ${COLOR_OFF}"
cd /home/$MYUSER/Downloads
sudo --user=$MYUSER wget https://framagit.org/efydd/dotfiles/-/archive/master/dotfiles-master.tar
sudo --user=$MYUSER tar xvf dotfiles-master.tar
sudo --user=$MYUSER mv .config          /home/$MYUSER/
sudo --user=$MYUSER mv .mozilla         /home/$MYUSER/
sudo --user=$MYUSER mv .var             /home/$MYUSER/
sudo --user=$MYUSER mv .Xdefaults       /home/$MYUSER/
sudo --user=$MYUSER mv .zshrc           /home/$MYUSER/
sudo --user=$MYUSER mv .bashrc          /home/$MYUSER/
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
echo -e "        ${GREEN} # Fedora/Centos fast install complete      ${COLOR_OFF}"
echo -e "        ${GREEN} ########################################## ${COLOR_OFF}"
echo
echo "end at $(date +\%F\ \%H:%M)"
echo
echo -e "${RED} Please reboot and check ${COLOR_OFF}"
echo
