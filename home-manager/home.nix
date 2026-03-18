{ pkgs, lib, config, ... }:
{
  #nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

  home.sessionVariables = {
    DOT_DIR = "${config.home.homeDirectory}/dotfiles";
    THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
    THEOSHELL_CDF_DIR = "${config.xdg.dataHome}/theoshell/cd-fav.txt";
  };

  imports = [
    # Tools
    ./config/git.nix
    ./config/fzf.nix
    ./config/fd.nix
    ./config/ripgrep.nix
    ./config/bat.nix
    ./config/btop.nix
    ./config/zathura.nix
    ./config/misc-pkgs.nix

    # Terminal & Shell
    ./config/kitty.nix
    ./config/starship.nix
    ./config/zsh.nix
    ./config/fish.nix
    ./config/fastfetch.nix
    ./config/neovide.nix

    # needs to be migrated to Nix
    ./config/nvim.nix
    ./config/lf.nix

    ## Linux only
    ./config/keychain.nix
    ./config/dunst.nix
    ./config/gammastep.nix
    ./config/waybar.nix
  ];

  programs.man.generateCaches = lib.mkIf pkgs.stdenv.isDarwin false;
  programs.home-manager.enable = true;


  home.stateVersion = "26.05";
}
