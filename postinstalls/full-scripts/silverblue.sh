#! /bin/bash
#
# postintall script for fedora silverblue
# install from https://silverblue.fedoraproject.org/download

######################### VARIABLES

# colors
RED="\033[1;31m"
GREEN="\033[1;32m"
COLOR_OFF="\033[0m"

######################### PERMISSIONS

# use it at root
if [ $EUID -ne 0 ] ; then
    echo "################################################################"
    echo -e "${RED}/""!""\\"" ${COLOR_OFF} You must be root to play the script. Please try again.  ""${RED}/""!""\\"" ${COLOR_OFF}"
    echo "################################################################"
    exit 1
fi

######################### START

clear

# banner and time
echo
echo -e "        ${GREEN} ################################################# ${COLOR_OFF}"
echo -e "        ${GREEN} # Fedora Silverblue  ${COLOR_OFF}"
echo -e "        ${GREEN} ################################################# ${COLOR_OFF}"
echo
echo "start at $(date +\%F\ \%H:%M)"
echo

# install and config of the firewall
echo -e "        ${GREEN} # Set the firewall to drop all ${COLOR_OFF}"
systemctl start firewalld
systemctl enable firewalld
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
# zone par defaut
firewall-cmd --set-default-zone=drop
# rechargement
firewall-cmd --reload
firewall-cmd --complete-reload
# vérification des règles
firewall-cmd --permanent --direct --get-all-rules
firewall-cmd --direct --get-all-rules
firewall-cmd --list-all
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# config of selinux
echo -e "        ${GREEN} # Check if selinux is enforce ${COLOR_OFF}"
systemctl restart selinux-basics.service
sestatus
sleep 3s
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# config of selinux
echo -e "        ${GREEN} # Disable useless services ${COLOR_OFF}"
systemctl disable chronyd.service
systemctl disable cups.service
systemctl disable bluetooth.service
systemctl disable nfs-client.target
systemctl disable nfs-convert.service
systemctl disable qemu-guest-agent.service
systemctl disable spice-vdagentd.socket
systemctl disable vboxservice.service
systemctl disable sshd
systemctl stop sshd
systemctl daemon-reload
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

######################### SOFTS

# install my softwares
echo -e "        ${GREEN} # Install only the packages you need ${COLOR_OFF}"
rpm-ostree install zsh gnome-tweaks
rpm-ostree upgrade
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# install my container
echo -e "        ${GREEN} # Create a container for basics need ${COLOR_OFF}"
sudo --user=$USER toolbox create --container workstation
chown -R $USER ~/.local/share/containers/storage/overlay-containers
echo -e "[${GREEN} DONE ${COLOR_OFF}]"
echo

# install my softwares with flatpak
echo -e "        ${GREEN} # Install only the flatpak you need ${COLOR_OFF}"
myflatpak="
com.sublimetext.three             # editor
io.neovim.nvim                    # editor
org.gnome.gedit                   # editor
org.gnome.Evince                  # pdf-viewer
io.github.GnomeMpv                # video-viewer
org.gnome.eog                     # image-viewer
org.gnome.FeedReader              # rss-viewer
org.mozilla.FirefoxDevEdition     # dev-firefox
freedesktop.Platform.ffmpeg       # audiosupport
io.gitlab.Goodvibes               # web radio
org.gnome.Calculator              # desktop-caculator
org.gnome.PasswordSafe            # security-passwords
org.gnome.Weather                 # weather-app
net.openra.OpenRA                 # game
org.gnome.Boxes                   # virtualization
"
flatpak remote-add --from org.mozilla.FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --assumeyes $myflatpak
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
