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

dnf upgrade --assumeyes --refresh
# basics tools
dnf install --assumeyes git rsync prename neovim
# softwares
dnf install --assumeyes chromium newsboat urlview keepassxc
# file manager
dnf install --assumeyes w3m-img ranger xclip highlight
# medias
dnf install --assumeyes mpv youtube-dl ffmpeg
# code
dnf install --assumeyes nodejs golang
# systems
dnf install --assumeyes tuned fira-code-fonts
# if AMD (thinkpad)
dnf install --assumeyes xorg-x11-drv-amdgpu

# power mangement
tuned --daemon --profile powersave
tuned-adm active
tuned-adm verify

# grub and autologin
sed --in-place 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/g' /etc/default/grub
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
sed --in-place 's/#autologin-user=/autologin-user=whoami/g' /etc/lightdm/lightdm.conf

# to disable wait for workspace login
# systemctl disable NetworkManager-wait-online.service
# gnome extension for tilling
# gnome-shell-extension-material-shell
# gnome-shell-extension-pop-shell

