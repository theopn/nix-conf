BOLD  := $(shell tput bold)
RED   := $(shell tput setaf 1)
GREEN := $(shell tput setaf 2)
BLUE  := $(shell tput setaf 4)
RESET := $(shell tput sgr0)

.PHONY: update clean history beauvoir wittgenstein wittgenstein-switch wittgenstein-test wittgenstein-boot
.DEFAULT_GOAL := $(shell hostname -s)

# Utility commands
update:
	@echo "$(BOLD)$(GREEN)===== Updating flake lock =====$(RESET)"
	nix flake update

clean:
	@echo "$(BOLD)$(GREEN)===== Running nix-collect-garbage =====$(RESET)"
	sudo nix-collect-garbage --delete-older-than 7d

history:
	@echo "$(BOLD)$(GREEN)===== Showing system generation history =====$(RESET)"
	nix profile history --profile /nix/var/nix/profiles/system

# hosts
beauvoir:
	@if [ "$$(uname)" != "Darwin" ]; then \
		echo "$(BOLD)$(RED)===== BEEP WRONG COMPUTER THEO =====$(RESET)"; \
		exit 1; \
	fi
	@echo "$(BOLD)$(BLUE)=====> Building beauvoir (M4 Mac Mini, nix-darwin) <=====$(RESET)"
	sudo darwin-rebuild switch --flake .#beauvoir

wittgenstein: wittgenstein-switch
wittgenstein-switch:
	@if [ "$$(uname)" != "Linux" ]; then \
		echo "$(BOLD)$(RED)===== okay an honest mistake =====$(RESET)"; \
		exit 1; \
	fi
	@echo "$(BOLD)$(BLUE)=====> Building wittgenstein (Framework 13 AMD 300 Series, NixOS) <=====$(RESET)"
	sudo nixos-rebuild switch --flake .#wittgenstein

wittgenstein-test:
	@if [ "$$(uname)" != "Linux" ]; then \
		echo "$(BOLD)$(RED)===== come on theo =====$(RESET)"; \
		exit 1; \
	fi
	@echo "$(BOLD)$(BLUE)=====> Testing wittgenstein <=====$(RESET)"
	sudo nixos-rebuild boot --flake .#wittgenstein

wittgenstein-boot:
	@if [ "$$(uname)" != "Linux" ]; then \
		echo "$(BOLD)$(RED)===== okay no way i would make this mistake =====$(RESET)"; \
		exit 1; \
	fi
	@echo "$(BOLD)$(BLUE)=====> Staging (next boot) wittgenstein <=====$(RESET)"
	sudo nixos-rebuild boot --flake .#wittgenstein
