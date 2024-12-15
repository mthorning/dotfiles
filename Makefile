.PHONY: install
install:
	brew bundle

	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

	export NVM_DIR="$$HOME/.nvm" && \
	[ -s "$(NVM_DIR)/nvm.sh" ] && \. "$(NVM_DIR)/nvm.sh" && \
	nvm install --lts && \
	nvm use --lts && \
	npm i -g pnpm

	curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh | bash

.PHONY: stow-shared
stow-shared:
	stow -d ./stowdirs/home -t $$HOME base

.PHONY: stow-home
stow-home:
	make stow-shared
	stow -d ./stowdirs/home -t $$HOME --override=".zshrc" home 

.PHONY: stow-work
stow-work:
	make stow-shared
	stow -d ./stowdirs/home -t $$HOME --override=".zshrc" work 
	stow -d ./stowdirs/etc/ -t /etc/ work
