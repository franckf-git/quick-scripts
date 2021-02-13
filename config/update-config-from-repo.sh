#! /bin/sh

# colors
RED="\033[1;31m"
GREEN="\033[1;32m"
COLOR_OFF="\033[0m"

echo -e "${GREEN} # Download my config files from gitlab and put them on ${COLOR_OFF}"

cd ~/Downloads
mkdir ~/Downloads/OLDconfig

wget https://framagit.org/efydd/config/-/archive/master/config-master.tar
tar xf config-master.tar

cd config-master
for dotfile in "
.Xdefaults
.bash.command-not-found
.bashrc
.check_repo.sh 
.gitconfig
.gtkrc-2.0"
do
    cp ~/$dotfile ~/Downloads/OLDconfig/
    cp $dotfile ~/
done

for dotfolder in "
.conky/
.noob/
.sec/
.surf/
.themes/"
do
    cp -r ~/$dotfolder ~/Downloads/OLDconfig/
    cp -r $dotfolder ~/
done

cd .config
for dotconfig in "
dunst
i3
i3status
nvim
rofi"
do
    cp -r ~/.config/$dotconfig ~/Downloads/OLDconfig/.config/
    cp -r $dotconfig ~/.config/
done

cp -r ~/.config/ranger ~/Downloads/OLDconfig/
rm -R ~/.config/ranger
ranger --copy-config=all
cp ranger/* ~/.config/ranger/

i3-msg restart

echo -e "[${GREEN} DONE ${COLOR_OFF}]"
