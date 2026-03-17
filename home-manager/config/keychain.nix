{ pkgs, lib, ... }:
{
  programs.keychain = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    keys = [ "id_ed25519" "id_rsa" ];
    extraFlags = [ "--quick" ];
  };
}
