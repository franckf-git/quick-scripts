#! /bin/bash
############ After workstation install
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
echo 'fastestmirror=true' >> /etc/dnf/dnf.conf
echo 'deltarpm=false' >> /etc/dnf/dnf.conf
echo 'keepcache=true' >> /etc/dnf/dnf.conf
#systemctl disable dnf-makecache.service
#systemctl disable dnf-makecache.timer
############ Disable unused services
systemctl list-units | grep service >> list-services
systemctl disable chronyd.service
systemctl disable cups.service
systemctl disable ModemManager.service
systemctl disable bluetooth.service
systemctl disable nfs-client.target
systemctl disable nfs-convert.service
systemctl disable qemu-guest-agent.service
systemctl disable spice-vdagentd.socket
systemctl disable vboxservice.service
systemctl disable cups.service
systemctl disable rtkit-daemon
systemctl disable postfix
systemctl disable sshd
systemctl stop sshd
systemctl daemon-reload
############ Flatpak
flatpak remote-add --if-not-exists flathub     https://flathub.org/repo/flathub.flatpakrepo
############ Install apps
### rpm fusion :
dnf install --assumeyes https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf upgrade --assumeyes
dnf install --assumeyes cockpit gnome-tweaks git rsync chromium tuned prename neovim newsboat keepassxc jetbrains-mono-fonts i3 rofi w3m-img ranger mpv youtube-dl light nodejs fira-code-fonts yarnpkg highlight
dnf autoremove --assumeyes libreoffice*
wget https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/29/Everything/x86_64/os/Packages/u/unclutter-8-17.fc29.x86_64.rpm
dnf install --assumeyes unclutter-8-17.fc29.x86_64.rpm

