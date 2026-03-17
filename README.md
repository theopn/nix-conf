# Theo's Nix Flakes

I got peer-pressured to using Nix, so here is my attempt at migrating my [other dotfiles repository](https://github.com/theopn/dotfiles) to Nix.

## Wittgenstein (Framework 13 w/ AMD Ryzen ~AI~ 5 340)

- `hosts/wittgenstein/configuration.nix`: main NixOS configuration; hardware services, user & environment, etc.
- `hosts/wittgenstein/hardware-configuration.nix`: hardware configuration for Framework 13 AMD + modifications to use `/dev/by-label` and LUKS encryption
- `hosts/wittgenstein/idkwhattoname.nix`: every other services, packages, and settings

### Minimal NixOS Installation with LUKS

TODO

## Beauvoir (M4 Mac Mini)

- `hosts/beauvoir/configuration.nix`: `nix-darwin` configuration with Homebrew casks and system settings
- `hosts/beauvoir/aerospace.nix`: Nix translation of my Aerospace config

### Determinate Nix Installation & Bootstrap

```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
nix run nix-darwin -- switch --flake .#beauvoir
```

## Home-manager

Largely the Nix rewrite of my [original dotfiles repository](https://github.com/theopn/dotfiles), but I tried to

1. use Nix modules whenever possible
2. unlike my original dotfiles, prefer third-party tools
3, only keep the features I use

It's cross-platform other than some Linux specific tools (e.g., keychian)

