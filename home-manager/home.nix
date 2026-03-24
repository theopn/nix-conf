{ pkgs, lib, config, ... }:

{
  xdg.enable = true;

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";

    THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
    THEOSHELL_CDF_DIR = "${config.xdg.dataHome}/theoshell/cd-fav.txt";
  };

  imports = [
    # Tools
    ./config/bat.nix
    ./config/btop.nix
    ./config/eza.nix
    ./config/fd.nix
    ./config/fzf.nix
    ./config/git.nix
    ./config/lf.nix
    ./config/ripgrep.nix
    ./config/vim.nix

    # Terminal & Shell
    ./config/fastfetch.nix
    ./config/fish.nix
    ./config/kitty.nix
    ./config/starship.nix
    ./config/zsh.nix

    # GUI tools
    ./config/librewolf.nix
    ./config/neovide.nix

    # nixvim
    ./nixvim/default.nix
  ];

  home.packages = with pkgs; [
    # tools
    tree
    openconnect
    #stow
    #tmux
    hugo
    wget

    # media
    exiftool
    figlet
    ffmpeg
    imagemagick

    # dev
    qemu
    nodejs_24
    python3
    #r
    cargo
    rustc
    sqlite
  ];

  programs.man.generateCaches = lib.mkIf pkgs.stdenv.isDarwin false;
  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
