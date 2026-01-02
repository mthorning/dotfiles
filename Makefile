.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make all           - Install homebrew, nvm, node, pnpm, and zinit"
	@echo "  make brew          - Install homebrew packages from Brewfile"
	@echo ""
	@echo "  make stow-shared   - Install shared/base configuration files"
	@echo "  make stow-personal - Install personal configuration (base + personal)"
	@echo "  make stow-work     - Install work configuration (base + work)"
	@echo ""
	@echo "  make unstow-shared   - Remove shared/base symlinks"
	@echo "  make unstow-personal - Remove personal configuration symlinks"
	@echo "  make unstow-work     - Remove work configuration symlinks"
	@echo "  make unstow-all      - Remove all stow-managed symlinks"

.PHONY: all
all:
	make brew

	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

	export NVM_DIR="$$HOME/.nvm" && \
	[ -s "$(NVM_DIR)/nvm.sh" ] && \. "$(NVM_DIR)/nvm.sh" && \
	nvm install --lts && \
	nvm use --lts && \
	npm i -g pnpm

	curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh | bash

.PHONY: brew
brew:
	brew bundle

.PHONY: stow-shared
stow-shared:
	stow -d ./stowdirs/home -t $$HOME base

.PHONY: stow-personal
stow-personal:
	make stow-shared
	stow -d ./stowdirs/home -t $$HOME --override=".zshrc" personal

.PHONY: stow-work
stow-work:
	make stow-shared
	stow -d ./stowdirs/home -t $$HOME --override=".zshrc" work

.PHONY: unstow-shared
unstow-shared:
	stow -d ./stowdirs/home -t $$HOME -D base

.PHONY: unstow-personal
unstow-personal:
	stow -d ./stowdirs/home -t $$HOME -D personal
	make unstow-shared

.PHONY: unstow-work
unstow-work:
	stow -d ./stowdirs/etc/ -t /etc/ -D work
	stow -d ./stowdirs/home -t $$HOME -D work
	make unstow-shared

.PHONY: unstow-all
unstow-all:
	-stow -d ./stowdirs/home -t $$HOME -D base personal work
	-stow -d ./stowdirs/etc/ -t /etc/ -D work
