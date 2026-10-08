{

  # packages, variables, and fallthrough NixOS settings
  flake.modules.nixos.nixos-base = { pkgs, inputs, ... }:
    # See https://github.com/NixOS/nixpkgs/issues/568692
    let
      pkgs-zotero = import inputs.nixpkgs-zotero {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    in
    {
    programs.firefox.enable = true;
    programs.thunderbird.enable = true;

    environment.systemPackages = with pkgs; [
      # paying the price for doing the minimal install
      curl wget gcc gdb git killall
      gnumake zip unzip file jq

      # uhh open source GUI tools
      brave gimp pkgs-zotero.zotero

      # Libreoffice
      libreoffice hunspell hunspellDicts.en_US


      # Propritery
      discord slack spotify zoom-us

      ### -------------------------------- ###
      ### packages that are no longer used ###
      ### -------------------------------- ###

      # CS489 stuff
      #arduino-ide kicad
    ];


    # Environment variables
    environment.localBinInPath = true;  # add ~/.local/bin to $PATH
    environment.variables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      LESSHISTFILE = "-";
    };

  };
}
