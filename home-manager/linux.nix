# Linux only config
{ pkgs, lib, config, ... }:

{
  imports = [
    ./config/copyq.nix
    ./config/keychain.nix
    ./config/zathura.nix

    # Niri
    ./config/dunst.nix
    ./config/gammastep.nix
    ./config/niri.nix
    ./config/rofi.nix
    ./config/swayidle.nix
    ./config/swaylock.nix
    ./config/waybar.nix
  ];
}
