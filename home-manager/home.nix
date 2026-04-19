{ pkgs, lib, config, ... }:

{
  xdg.enable = true;

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";

    THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
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
    ./config/neovide.nix
    ./config/ripgrep.nix
    ./config/syncthing.nix
    ./config/vim.nix
    ./config/zoxide.nix

    # Terminal & Shell
    ./config/fastfetch.nix
    ./config/fish.nix
    ./config/kitty.nix
    ./config/starship.nix
    ./config/zsh.nix

    # someone couldn't handle true privacy
    #./config/librewolf.nix

    # nixvim
    ./nixvim/default.nix
  ];

  home.packages = with pkgs; [
    # tools
    hugo
    openconnect
    qemu
    #tmux
    tree
    wget

    # media
    exiftool
    ffmpeg
    figlet
    imagemagick

    # dev
    nodejs_24
    python3
    #r
    cargo
    rustc
    sqlite

    # Horrible name, but platformio = platformio-chrootenv = FHS wrapper for Linux
    # Configuring udev rule doesn't seem to be necessary as long as `dialout` group is set
    # https://docs.platformio.org/en/stable//core/installation/udev-rules.html
    (if stdenv.isLinux then platformio else platformio-core)
  ];

  programs.man.generateCaches = lib.mkIf pkgs.stdenv.isDarwin false;
  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
