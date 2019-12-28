#! /bin/bash
# After workstation install
# Firewall and SElinux
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
# DNF optimisations
echo 'fastestmirror=true' >> /etc/dnf/dnf.conf
echo 'deltarpm=false' >> /etc/dnf/dnf.conf
echo 'keepcache=true' >> /etc/dnf/dnf.conf
#systemctl disable dnf-makecache.service
#systemctl disable dnf-makecache.timer
# Disable unused services
systemctl disable chronyd.service
systemctl disable cups.service
systemctl disable ModemManager.service
systemctl disable bluetooth.service
systemctl disable nfs-client.target
systemctl disable nfs-convert.service
systemctl disable qemu-guest-agent.service
systemctl disable spice-vdagentd.socket
systemctl disable vboxservice.service
systemctl disable sshd
systemctl stop sshd
systemctl daemon-reload
# Flatpak
flatpak remote-add --if-not-exists flathub     https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists fedora      oci+https://registry.fedoraproject.org
flatpak remote-add --if-not-exists firefoxrepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
# Install apps
dnf upgrade --assumeyes
dnf install --assumeyes zsh cockpit gnome-tweaks git htop rsync chromium neovim tuned prename
flatpak install flathub --assumeyes io.github.celluloid_player.Celluloid
flatpak install flathub --assumeyes org.gnome.FeedReader
flatpak install flathub --assumeyes io.gitlab.Goodvibes
flatpak install flathub --assumeyes io.freetubeapp.FreeTube
# Uninstall some very RAM hungry apps
dnf autoremove --assumeyes PackageKit gnome-software
dnf autoremove --assumeyes abrt*
dnf autoremove --assumeyes libvirt* gnome-boxes