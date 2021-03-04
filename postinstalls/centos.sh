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
# epel
dnf install --assumeyes epel-release
# rpm fusion
dnf install --nogpgcheck --assumeyes https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
dnf install --nogpgcheck --assumeyes https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
dnf config-manager --enable powertools

# if minimal install
# dnf install gnome-shell gdm gnome-tweaks nautilus gnome-terminal
# systemctl set-default graphical.target

dnf upgrade --assumeyes

# to disable wait for workspace login
# systemctl disable NetworkManager-wait-online.service
