source ~/dotfiles/home/personal/.zshrc

tmux_work() {
	nmcli con up id hf-dev-vpn
	pactl set-default-sink alsa_output.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock_1__sink
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
	i3-msg 'workspace 2; exec teams'
	i3-msg 'workspace 4; append_layout /home/mthorning/.config/i3/layout-4.json'
	i3-msg exec pavucontrol
	i3-msg exec joplin
	i3-msg exec blueman-manager
}

work() {
	i3_work
	tmux_work
	pactl set-default-sink alsa_output.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock_1__sink
}

dev() {
    	nodemon --exec "babel src --root-mode upward --out-dir dist --source-maps --ignore '**/*.spec.js' && rsync -av --include='*.scss' --include='*.less'  --include='*.json' --exclude='*' src/ dist/ && yalc publish . --push" --verbose ./src --ignore dist
}

