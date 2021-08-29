#! /bin/bash
echo "
PATH=$PATH:/usr/sbin" >> /root/.bashrc
export PATH=$PATH:/usr/sbin
############ Repos
echo "
deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free

deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-updates main contrib non-free
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
# aa-unconfined
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
############ Install apps

apt-get dist-upgrade --assume-yes
# flatpak
apt install --assume-yes flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --assumeyes com.github.tchx84.Flatseal
flatpak install --assumeyes org.chromium.Chromium
flatpak install --assumeyes org.keepassxc.KeePassXC
flatpak install --assumeyes org.freedesktop.Sdk.Extension.golang
flatpak install --assumeyes com.vscodium.codium

# basics tools
apt install --assume-yes git
apt install --assume-yes rsync
# softwares
apt install --assume-yes rename
apt install --assume-yes neovim
apt install --assume-yes newsboat
# file manager
apt install --assume-yes ranger
apt install --assume-yes highlight
# medias
apt install --assume-yes mpv
apt install --assume-yes youtube-dl
apt install --assume-yes ffmpeg
apt install --assume-yes ImageMagick
# systems
apt install --assume-yes fira-code-fonts
apt install --assume-yes tuned
apt install --assume-yes gnome-tweaks
# code
apt install --assume-yes entr
apt install --assume-yes golang
# firmware
apt install --assume-yes firmware-linux
apt install --assume-yes firmware-linux-free
apt install --assume-yes firmware-linux-nonfree
apt install --assume-yes firmware-iwlwifi
# if AMD (thinkpad)
apt install --assume-yes xserver-xorg-video-amdgpu
apt install --assume-yes amd64-microcode
# else
apt install --assume-yes intel-microcode

apt autoremove --assume-yes
apt autoclean --assume-yes

############ OPTIMIZE
# GRUB
sed --in-place 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/g' /etc/default/grub
update-grub
# SSD
sed --in-place 's/defaults/defaults,discard/g' /etc/fstab
# laptop mode
echo "
vm.laptop_mode = 5 " >> /etc/sysctl.conf
# lower swap level
echo "
vm.swappiness = 10 " >> /etc/sysctl.conf
# touchpad
apt-get remove xserver-xorg-input-synaptics
apt-get install xserver-xorg-input-libinput
mkdir /etc/X11/xorg.conf.d
echo 'Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf
# autologin
sed --in-place 's/#autologin-user=/autologin-user=user/g' /etc/lightdm/lightdm.conf
# power mangement
tuned --daemon --profile powersave
tuned-adm active
tuned-adm verify

# extra security
dpkg --verify
apt install checksecurity chkrootkit rkhunter

