{ pkgs, ... }:
{
  # homebrew = {
  #   enable = true;
  #
  #   # Delete unspecified Homebrew formulae
  #   onActivation.cleanup = "zap";
  # };

  environment.systemPackages = [
    pkgs.lf
    pkgs.neovim
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  system.primaryUser = "theopn";
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.1;          # how long to hold the mouse
      autohide-time-modifier = 0.3;  # animation speed
      orientation = "left";
      persistent-apps = [
      {
        spacer = {
          small = false;
        };
      }
      ];
      persistent-others = [
          { folder = "/Users/@username@/Downloads"; }
      ];
      showhidden = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };
    screencapture = {
      #location = "${HOME}/Downloads";
      type = "png";
    };
  };
  system.keyboard.remapCapsLockToControl = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  nix.settings.experimental-features = "nix-command flakes";

  # Turn nix-darwin from managing the installed version of nix,
  # since Determinate already does.
  nix.enable = false;

  system.stateVersion = 6;
}
