#! /bin/bash

mkdir Configurations

for files in $(ls -1d .??*)
    do
        mv $files Configurations/
        ln -s Configurations/$files $files
done

exit $?