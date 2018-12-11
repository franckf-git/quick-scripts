#! /bin/sh

# colors
RED="\033[1;31m"
GREEN="\033[1;32m"
COLOR_OFF="\033[0m"

echo -e "${GREEN} # Download my config files from gitlab and put them on ${COLOR_OFF}"

ranger --copy-config=all
cd ~/Downloads
wget https://framagit.org/efydd/config/-/archive/master/config-master.tar
tar xvf config-master.tar

cd config-master
for dotfile in "
.Xdefaults
.bash.command-not-found
.bashrc
.gitconfig
.gtkrc-2.0"
do
    mv --force $dotfile ~/
done

for dotfolder in "
.cheat/
.conky/
.rtfm/
.sec/
.themes/
.tldr/"
do
    mv --force $dotfolder/* ~/$dotfolder/
done

cd ~/Downloads/config-master
for dotconfig in "
i3
i3status
nvim
ranger"
do
    mv .config/$dotconfig/* ~/.config/$dotconfig/
done

echo -e "[${GREEN} DONE ${COLOR_OFF}]"
