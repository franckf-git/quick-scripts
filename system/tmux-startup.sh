#! /bin/sh

# variables
SESSION=FF
WIN0=TODO
WIN1=1
WIN2=2
WIN3=3
WIN4=4
WIN5=5
WIN6=6
WIN7=GRID

# create windows
tmux new-session -s $SESSION -d -n $WIN0
tmux new-window  -t $SESSION -d -n $WIN1
tmux new-window  -t $SESSION -d -n $WIN2
tmux new-window  -t $SESSION -d -n $WIN3
tmux new-window  -t $SESSION -d -n $WIN4
tmux new-window  -t $SESSION -d -n $WIN5
tmux new-window  -t $SESSION -d -n $WIN6
tmux new-window  -t $SESSION -d -n $WIN7

# style
tmux set-option -s -t $SESSION status off
tmux unbind C-b
tmux set -g prefix C-q

# commands for each windows
tmux send-keys -t $SESSION:$WIN0 "nvim -p readme.md todo.md" Enter
tmux send-keys -t $SESSION:$WIN1 "" Enter
tmux send-keys -t $SESSION:$WIN2 "" Enter
tmux send-keys -t $SESSION:$WIN3 "" Enter
tmux send-keys -t $SESSION:$WIN4 "" Enter
tmux send-keys -t $SESSION:$WIN5 "" Enter
tmux send-keys -t $SESSION:$WIN6 "" Enter

# special window with grid
tmux select-window -t $SESSION:$WIN7
tmux send-keys -t     $SESSION:$WIN7 "echo 1" Enter
tmux split-window -h
tmux send-keys -t     $SESSION:$WIN7 "echo 2" Enter
tmux split-window -v
tmux send-keys -t     $SESSION:$WIN7 "echo 3" Enter
tmux split-window -h
tmux send-keys -t     $SESSION:$WIN7 "echo 4" Enter
tmux select-layout tiled
# define size of panes
# tmux resize-pane   -t $SESSION -L 30

# launch tmux with $WIN0 first
tmux select-window -t $SESSION:$WIN0
tmux -u attach -t     $SESSION

