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
# if AMD (thinkpad) ??
#dnf install --assumeyes xorg-x11-drv-amdgpu
