source ~/dotfiles/home/.zshrc

tmux_work() {
	nmcli con up id hf-dev-vpn
	cd ~/bespin
	
	SESSION="proxy"
	SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
	
	if [ "$SESSIONEXISTS" = "" ]
	then
	    tmux new-session -d -s $SESSION 
	    tmux send-keys -t $SESSION:1 'cd focus/proxy' Enter
	    tmux send-keys -t $SESSION:1 'npm start -- -lr' Enter
	fi
	
	
	tmux attach-session -t $SESSION:1
}

i3_work() {
	i3-msg 'workspace 4; append_layout /home/mthorning/.config/i3/layout-4.json'
	i3-msg exec pavucontrol
	i3-msg exec joplin
	i3-msg exec blueman-manager
	i3-msg workspace 2
	i3-msg exec teams
	sleep 3
	i3-msg 'workspace 1; layout tabbed; exec chromium; focus left'
}

work() {
	i3_work
	tmux_work
}

dev() {
    	nodemon --exec "babel src --root-mode upward --out-dir dist --ignore '**/*.spec.js' && rsync -av --include='*.scss' --include='*.less'  --include='*.json' --exclude='*' src/ dist/ && yalc publish . --push" --verbose ./src --ignore dist
}

