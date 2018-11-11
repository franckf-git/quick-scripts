#!/bin/bash

urxvt -e vimx /home/$USER/script.sh &
urxvt -e vimx /home/$USER/mrak.md &
urxvt -e vimx temp &

i3-msg  layout  tabbed
