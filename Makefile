hostname := $(shell uname -n)

.PHONY: switch
switch:
	home-manager switch --flake .#$(hostname)

.PHONY: clean
clean:
	nix-collect-garbage -d

.PHONY: bootstrap-nix
bootstrap-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
