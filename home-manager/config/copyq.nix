{ config, pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  services.copyq = {
    enable = true;
  };
}
