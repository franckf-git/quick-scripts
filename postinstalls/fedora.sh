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
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --assumeyes com.github.tchx84.Flatseal
flatpak install --assumeyes ca.desrt.dconf-editor
flatpak install --assumeyes io.mpv.Mpv
flatpak install --assumeyes org.chromium.Chromium
flatpak install --assumeyes org.keepassxc.KeePassXC
flatpak install --assumeyes org.freedesktop.Sdk.Extension.golang
flatpak install --assumeyes com.vscodium.codium
############ Install apps
# rpm fusion
rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
rpm-ostree install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

rpm-ostree upgrade
# softwares
rpm-ostree install prename
rpm-ostree install neovim
rpm-ostree install newsboat
# file manager
rpm-ostree install ranger
rpm-ostree install highlight
# medias
rpm-ostree install youtube-dl
rpm-ostree install ffmpeg
rpm-ostree install ImageMagick
# systems
rpm-ostree install fira-code-fonts
rpm-ostree install tuned
# code
rpm-ostree install entr
rpm-ostree install golang
# if AMD (thinkpad)
rpm-ostree install xorg-x11-drv-amdgpu

# power mangement
tuned --daemon --profile powersave
tuned-adm active
tuned-adm verify

# grub
sed --in-place 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/g' /etc/default/grub
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

