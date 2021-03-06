#! /bin/sh

# script for unzip scan and have all images in one folder

# put the path with as argument
MYPATH=$1
cd $MYPATH

mkdir -p ~/Downloads/tmp
mkdir -p ~/Downloads/the_scans

for i in $(ls $MYPATH)
    do
        cd $MYPATH
        unzip $MYPATH/$i
        find $MYPATH -name "*.png" -exec mv {} ~/Downloads/tmp \;
        find $MYPATH -name "*.jpg" -exec mv {} ~/Downloads/tmp \;
        find $MYPATH -name "*.gif" -exec mv {} ~/Downloads/tmp \;
for j in $(ls ~/Downloads/tmp | grep 'jpg\|png\|gif')
        do
            cd ~/Downloads/tmp
            prename -v 's/^/'$i'\_/' $j
            prename 's/.zip//' *
        done
        cd ~/Downloads/tmp
        mv *.* ~/Downloads/the_scans
        
    done

rm -R ~/Downloads/tmp
# rotate for read on the side
#convert source.png -rotate -90 destination.png

echo "############################"
echo "our scans are ready. Enjoy !"
echo "############################"
