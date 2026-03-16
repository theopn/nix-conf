{ pkgs, lib, config, ... }:
{
  #nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    LESSHISTFILE = "-";
    DOT_DIR = "${config.home.homeDirectory}/dotfiles";
    THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
    THEOSHELL_CDF_DIR = "${config.xdg.dataHome}/theoshell/cd-fav.txt";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  imports = [
    # Tools
    ./config/git.nix
    ./config/fzf.nix
    ./config/fd.nix
    ./config/ripgrep.nix
    ./config/bat.nix
    ./config/btop.nix
    ./config/misc-pkgs.nix

    # Shell related
    ./config/starship.nix
    ./config/zsh.nix
    ./config/fish.nix
    ./config/fastfetch.nix
    ./config/neovide.nix

    # needs to be migrated to Nix
    ./config/nvim.nix
    ./config/lf.nix

    # GUI tools
    ./config/kitty.nix
    ./config/wezterm.nix
    ./config/zathura.nix

    # macOS specific
    ./config/aerospace.nix
  ];
  # ++ lib.optionals pkgs.stdenv.isLinux [
  # ]
  # ++ lib.optionals pkgs.stdenv.isDarwin [
  # ];

  programs.man.generateCaches = lib.mkIf pkgs.stdenv.isDarwin false;
  programs.home-manager.enable = true;


  home.stateVersion = "26.05";
}
