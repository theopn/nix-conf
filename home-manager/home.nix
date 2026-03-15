{ pkgs, lib, ... }:
{
  #nixpkgs.config.allowUnfree = true;

  imports = [
    # Config written in pure Nix
    ./config/git.nix
    ./config/fzf-fd-rg.nix
    ./config/shell.nix
    ./config/fastfetch.nix
    ./config/neovide.nix
    ./config/bat.nix
    ./config/btop.nix

    # symlinks
    ./config/nvim.nix
    ./config/lf.nix

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
