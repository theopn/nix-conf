{ pkgs, lib, ... }:
{
  #nixpkgs.config.allowUnfree = true;

  imports = [
    ./config/git.nix
    ./config/fzf.nix
    ./config/fd.nix
    ./config/ripgrep.nix
    ./config/shell.nix
    ./config/fastfetch.nix
    ./config/neovide.nix
    ./config/bat.nix
    ./config/btop.nix
    # needs to be migrated to Nix
    ./config/nvim.nix
    ./config/lf.nix

    # GUI tools
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
