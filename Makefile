hostname := $(shell uname -n)

.PHONY: update
update:
	nix flake update
	home-manager switch --flake .#$(hostname)

.PHONY: clean
clean:
	nix-collect-garbage -d

.PHONY: bootstrap-nix
bootstrap-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	nix run github:nix-community/home-manager -- switch --flake .
