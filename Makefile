.PHONY: update
switch:
	home-manager switch --flake .#myprofile

.PHONY: clean
clean:
	nix-collect-garbage -d

.PHONY: bootstrap-nix
bootstrap-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
