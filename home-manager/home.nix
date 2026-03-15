{ pkgs, lib, ... }:
{
  #nixpkgs.config.allowUnfree = true;

  imports = [
    # Config written in pure Nix
    ./config/fzf-fd-rg.nix
    ./config/shell.nix
    ./config/fastfetch.nix

    # symlinks
    ./config/nvim.nix
    ./config/lf.nix

    ./config/aerospace.nix
  ];
  # ++ lib.optionals pkgs.stdenv.isLinux [
  # ]
  # ++ lib.optionals pkgs.stdenv.isDarwin [
  # ];

  programs.home-manager.enable = true;


  home.stateVersion = "26.05";
}
