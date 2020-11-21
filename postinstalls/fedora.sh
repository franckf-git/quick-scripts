#! /bin/bash
############ Firewall and SElinux
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=drop
firewall-cmd --complete-reload
firewall-cmd --permanent --direct --get-all-rules
firewall-cmd --direct --get-all-rules
firewall-cmd --list-all
sleep 3s
systemctl restart selinux-basics.service
sestatus
sleep 3s
############ DNF optimisations
echo 'fastestmirror=true'      >> /etc/dnf/dnf.conf
echo 'deltarpm=false'          >> /etc/dnf/dnf.conf
echo 'keepcache=true'          >> /etc/dnf/dnf.conf
echo 'install_weak_deps=false' >> /etc/dnf/dnf.conf
############ Disable unused services
systemctl disable ModemManager.service
systemctl disable bluetooth.service
systemctl disable chronyd.service
systemctl disable cups.service
systemctl disable nfs-client.target
systemctl disable nfs-convert.service
systemctl disable postfix
systemctl disable qemu-guest-agent.service
systemctl disable rtkit-daemon
systemctl disable spice-vdagentd.socket
systemctl disable sshd
systemctl disable vboxservice.service
systemctl stop sshd
systemctl daemon-reload
############ Flatpak
flatpak remote-add --if-not-exists flathub     https://flathub.org/repo/flathub.flatpakrepo
############ Install apps
# rpm fusion
dnf install --assumeyes https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install --assumeyes https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# if minimal install
# dnf install gnome-shell gdm gnome-tweaks nautilus gnome-terminal
# systemctl set-default graphical.target

dnf upgrade --assumeyes
# basics tools
dnf install --assumeyes git rsync prename neovim feh rxvt-unicode
# softwares
dnf install --assumeyes chromium-browser-privacy newsboat keepassxc
# window manager
dnf install --assumeyes bspwm sxhkd rofi w3m-img ranger highlight
# medias
dnf install --assumeyes mpv youtube-dl
# code
dnf install --assumeyes nodejs yarnpkg
# systems
dnf install --assumeyes tuned light fira-code-fonts cockpit
wget https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/29/Everything/x86_64/os/Packages/u/unclutter-8-17.fc29.x86_64.rpm
dnf install --assumeyes unclutter-8-17.fc29.x86_64.rpm
rm unclutter-8-17.fc29.x86_64.rpm
# if AMD (thinkpad)
dnf install --assumeyes xorg-x11-drv-amdgpu

# to disable wait for workspace login
# systemctl disable NetworkManager-wait-online.service
