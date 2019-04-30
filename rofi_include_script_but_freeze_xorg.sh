#! /bin/sh

#rofi -modi "run,drun,window,combi,ssh,test:~/test.sh" -show window -sidebar-mode -show-icons -drun-icon-theme
if [ -z $@ ]
then

echo -e "\
 brave\n\
 chromium\
"

else
    CHOIX=$@
    case "${CHOIX}" in
        " brave"             ) brave-browser-stable ;;
        " chromium"          ) chromium-browser --incognito ;;
    esac
fi

