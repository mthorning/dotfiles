source ~/dotfiles/home/.zshrc

work() {
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
	
	
	tmux attach-session -t 1:1
}

dev() {
    	nodemon --exec "babel src --root-mode upward --out-dir dist --ignore '**/*.spec.js' && rsync -av --include='*.scss' --include='*.less'  --include='*.json' --exclude='*' src/ dist/ && yalc publish . --push" --verbose ./src --ignore dist
}

