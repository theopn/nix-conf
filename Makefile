update:
	nix flake update

wittgenstein:
	sudo nixos-rebuild switch --flake .#wittgenstein

beauvoir:
	sudo darwin-rebuild switch --flake .#beauvoir

clean:
	sudo nix-collect-garbage -d
