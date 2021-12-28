#! /bin/bash
############ DNF optimisations
echo 'fastestmirror=true'      >> /etc/dnf/dnf.conf
echo 'deltarpm=false'          >> /etc/dnf/dnf.conf
echo 'keepcache=true'          >> /etc/dnf/dnf.conf
echo 'install_weak_deps=false' >> /etc/dnf/dnf.conf
############ Install apps
# rpm fusion
dnf install --assumeyes https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install --assumeyes https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# softwares
dnf install --assumeyes prename
dnf install --assumeyes neovim
dnf install --assumeyes xclip
dnf install --assumeyes newsboat
dnf install --assumeyes epiphany
dnf install --assumeyes feh
dnf install --assumeyes evince
# file manager
dnf install --assumeyes ranger
dnf install --assumeyes highlight
# medias
dnf install --assumeyes mpv
dnf install --assumeyes youtube-dl yt-dlp
dnf install --assumeyes ffmpeg
dnf install --assumeyes ImageMagick
# code
dnf install --assumeyes golang

# fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip
unzip Fira_Code_v6.2.zip
