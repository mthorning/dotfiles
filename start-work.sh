#!/bin/bash

nmcli con up id hf-dev-vpn
cd ~/bespin

SESSION="proxy"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

if [ "$SESSIONEXISTS" = "" ]
then
    tmux new-session -d -s $SESSION 
    tmux send-keys -t $SESSION:1 'cd focus/proxy' Enter
    tmux send-keys -t $SESSION:1 'npm start -- -lr' Enter

    tmux new-session -d -s 1
fi


tmux attach-session -t $SESSION:0
