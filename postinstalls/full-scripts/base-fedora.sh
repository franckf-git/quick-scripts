#! /bin/bash
############ After workstation install
echo "After install and before reboot - you can install software on the live"
echo "Change the mount folder to the new installed partition :"
echo "sudo chroot /mnt/sysroot /bin/bash"
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
flatpak remote-add --if-not-exists fedora      oci+https://registry.fedoraproject.org
############ Install apps
### centos : 
#dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#dnf install --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
#dnf install --nogpgcheck https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
#dnf config-manager --enable PowerTools
#dnf config-manager --set-enabled extras
### rpm fusion :
#dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf upgrade --assumeyes
dnf install --assumeyes zsh cockpit gnome-tweaks git htop rsync chromium tuned prename neovim newsboat keepassxc jetbrains-mono-fonts
#dnf install --assumeyes i3 rofi w3m-img ranger tmux numlockx
#--setopt=install_weak_deps=False
flatpak install flathub --assumeyes io.github.celluloid_player.Celluloid
flatpak install flathub --assumeyes io.freetubeapp.FreeTube
############ Uninstall some very RAM hungry apps
dnf autoremove --assumeyes PackageKit gnome-software
dnf autoremove --assumeyes abrt*
dnf autoremove --assumeyes libvirt* gnome-boxes
