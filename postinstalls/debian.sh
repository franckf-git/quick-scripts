#! /bin/bash
# TODO test on install
# Repos
echo "
# Security updates
deb http://security.debian.org/ buster/updates main contrib non-free
deb-src http://security.debian.org/ buster/updates main contrib non-free

## Debian mirror

# Base repository
deb https://deb.debian.org/debian buster main contrib non-free
deb-src https://deb.debian.org/debian buster main contrib non-free

# Stable updates
deb https://deb.debian.org/debian buster-updates main contrib non-free
deb-src https://deb.debian.org/debian buster-updates main contrib non-free

# Stable backports
#deb https://deb.debian.org/debian buster-backports main contrib non-free
#deb-src https://deb.debian.org/debian buster-backports main contrib non-free
" > /etc/apt/sources.list
echo '
APT::Install-Recommends "false";
APT::Install-Suggests "false";
APT::Get::Install-Recommends "false";
APT::Get::Install-Suggests "false";
' > /etc/apt/apt.conf
apt-get update --assume-yes
############ Firewall and AppArmors
apt-get install --assume-yes ufw
sed --in-place 's/IPV6=yes/IPV6=no/g' /etc/default/ufw
ufw enable
ufw default deny incoming
ufw default deny outgoing
ufw allow out 80/tcp
ufw allow out 443/tcp
ufw allow out 53/udp
ufw status verbose
sleep 3s
apt-get install --assume-yes apparmor-profiles apparmor-utils
aa-enforce /etc/apparmor.d/*
aa-status
sleep 3s
############ Disable unused services
systemctl disable ModemManager.service
systemctl disable bluetooth.service
systemctl disable chronyd.service
systemctl disable cups.service
systemctl disable exim4.service
systemctl disable nfs-client.target
systemctl disable nfs-convert.service
systemctl disable postfix
systemctl disable qemu-guest-agent.service
systemctl disable rpcbind.service
systemctl disable rpcbind.socket
systemctl disable rtkit-daemon
systemctl disable spice-vdagentd.socket
systemctl disable sshd
systemctl disable vboxservice.service
systemctl stop sshd
systemctl daemon-reload
############ Flatpak
apt-get install --assume-yes flatpak
flatpak remote-add --if-not-exists flathub     https://flathub.org/repo/flathub.flatpakrepo
############ Install apps
# if minimal install
# apt-get install --no-install-recommends --assume-yes gnome-core gdm3 network-manager-gnome
# systemctl set-default graphical.target

apt-get upgrade --assume-yes
# basics tools
apt-get install --assume-yes git rsync rename neovim feh rxvt-unicode
# softwares
apt-get install --assume-yes chromium newsboat keepassxc
# window manager
apt-get install --assume-yes bspwm sxhkd rofi w3m-img ranger highlight
# medias
apt-get install --assume-yes mpv youtube-dl
# code
apt-get install --assume-yes nodejs yarnpkg
# systems
apt-get install --assume-yes tuned unclutter fonts-firacode
apt-get install --assume-yes firmware-linux firmware-linux-free firmware-linux-nonfree firmware-iwlwifi
# if AMD (thinkpad)
apt-get install --assume-yes xserver-xorg-video-amdgpu
tasksel --task-packages laptop

apt-get autoremove --assume-yes
apt-get autoclean --assume-yes

############ OPTIMIZE
sed --in-place='s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/g' /etc/default/grub
update-grub
# SSD
sed --in-place='s/defaults/defaults,discard/g' /etc/fstab
sed --in-place='s/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf
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
