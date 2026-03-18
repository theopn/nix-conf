{ pkgs, lib, config, ... }:

{
  xdg.enable = true;

  home.sessionVariables = {
    DOT_DIR = "${config.home.homeDirectory}/dotfiles";
    THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
    THEOSHELL_CDF_DIR = "${config.xdg.dataHome}/theoshell/cd-fav.txt";
  };

  imports = [
    # Tools
    ./config/bat.nix
    ./config/btop.nix
    ./config/fd.nix
    ./config/fzf.nix
    ./config/git.nix
    ./config/lf.nix
    ./config/ripgrep.nix
    ./config/zathura.nix

    # Terminal & Shell
    ./config/kitty.nix
    ./config/starship.nix
    ./config/zsh.nix
    ./config/fish.nix
    ./config/fastfetch.nix
    ./config/neovide.nix

    ./config/misc-pkgs.nix

    # needs to be migrated to Nix
    ./config/nvim.nix
  ];

  programs.man.generateCaches = lib.mkIf pkgs.stdenv.isDarwin false;
  programs.home-manager.enable = true;


  home.stateVersion = "26.05";
}
