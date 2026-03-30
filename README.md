# Theo's Nix Flake

| ![niri-sc](https://raw.githubusercontent.com/theopn/haunted-tiles/refs/heads/main/assets/niri-sc.png) |
| :--:                                                                                                  |
| NixOS + Niri in Wittgenstein (Framework 13)                                                           |

I was peer-pressured into using Nix.
And I am glad I was; it turned out to be perfect for a control freak like me.

This repository is largely based on my [original dotfiles](https://github.com/theopn/dotfiles).
Rather than a 1:1 port, I've used the Nix migration as an excuse to cut out unused tools and simplify my overall setup (e.g., swapping custom Lua code for [`mini.nvim`](https://github.com/nvim-mini/mini.nvim) modules, and turning my Zsh config into a stable login shell while moving features to Fish, which is my interactive shell in Kitty).

> [!NOTE]
> My [original dotfiles repository](https://github.com/nvim-mini/mini.nvim) isn't dead.
> I will backport any major changes there.
> Because you never know when the urge to distrohop will strike again.


## `flake.nix` Overview

`flake.nix` takes 5 inputs:

- `nixpkgs-unstable`
- `nixos-hardware`
- `nix-darwin`
- `home-manager`
- `nixvim`

and produces 2 outputs

- `beauvoir`: a `nix-darwin` module for my M4 Mac Mini.
- `wittgenstein`: a NixOS module for my Framework 13.

## Update Workflow

I run `make update` in the `flake-update-testing` branch every 2 weeks or so.
Then I iron out any breaking changes and implement new features associated with the package update.
Once the system becomes stable, `flake-update-testing` is merged into `main`, and the cycle repeats.


## `wittgenstein`

### Prerequisites

See my [NixOS Minimal Installation with LUKS Encryption Guide](./nixos-minimal-install-w-luks.md).

### Post-installation

Since I have no display manager, you will be dropped into a TTY upon boot.

1. Use `keychain_load` alias in Zsh to manually load SSH keys.
    I intentionally disabled Zsh integration to prevent blocking the login shell.
    Manual loading ensures the SSH agent is inherited by all child processes.
2. Use `niri-session` to launch Niri alongside necessary `systemd` services (swayidle, Waybar, etc., managed via the `niri.session` target).
3. Set the wallpaper and generated a cached lockscreen image using
    ```sh
    theo-set-wallpaper /path/to/any/image/that/is/accepted/in/imagemagick
    ```

### Structure

- `hosts/wittgenstein/configuration.nix`: core system definition.
    Handles hardware services (e.g., pipewire), user settings, and global environment variables.
    I offload as much as possible to home-manager.
- `hosts/wittgenstein/idkwhattoname.nix`: other system-level services and programs that require little to no configurations.
- `hosts/wittgenstein/hardware-configuration.nix`: (almost) auto-generated hardware configuration for Framework 13.
    Manually patched for LUKS compatibility and hibernation.


## `beauvoir`

### Prerequisites

```sh
# Install Determinate Nix
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

cd && git clone git@github.com:theopn/nix-conf.git
cd ~/nix-conf
nix run nix-darwin -- switch --flake .#beauvoir
```

### Post-installation

- Since I don't use a GUI wrapper, bookmark `http://127.0.0.1:8384/` (Syncthing web UI).

### Structure

- `hosts/beauvoir/configuration.nix`: the primary `nix-darwin` configuration with macOS settings and global variables.
- `hosts/beauvoir/homebrew.nix`: Manages Homebrew Casks for GUI applications that don't benefit from declarative configuration or version locking (e.g., Slack, KiCad)
- `hosts/beauvoir/aerospace.nix`: a Nix translation of my Aerospace config


## Home-manager

The Code is intended to be self-explanatory.

- `home-manager/home.nix`: define user-level variables and imports cross-platform tools.
- `home-manager/linux.nix`: Linux-specific imports and services (e.g., imv, mpv, zathura, and Niri dependencies)
- `home-manager/config`: all individual config files for programs/services.
    All sub-directories house non-Nix config files.
    For example, `home-manager/config/lf` contains the standard `icons_colored` definition from the [official `lf` repository](https://github.com/gokcehan/lf/blob/master/etc/icons_colored.example).


## Nixvim

TODO: insert screenshot

It is a simplified version of my previous Neovim setup.

- I am an advocate for Vim's native tab system and try to avoid "bufferline" plugins.
    My [`tabby.nvim`](https://github.com/nanozuki/tabby.nvim) config provides a nice middle ground between native tab system and a visible buffer list.

