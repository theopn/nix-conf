{ pkgs, ... }:
let
  externalAppDir = "/Volumes/theo-crucial-p310/Applications";
in
{

  imports = [
    ./aerospace.nix
  ];

  users.users.theopn = {
    name = "theopn";
    home = "/Users/theopn";
  };

  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    LESSHISTFILE = "-";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt
    nerd-fonts.fantasque-sans-mono
  ];

  homebrew = {
    enable = true;
    casks = [
      # Dev tools
      "docker-desktop"
      #{
      # name = "docker-desktop";
      # args = { appdir = externalAppDir };
      #}
      #"intellij-idea"
      "macvim-app"
      #"rstudio"
      #"wezterm"

      # Fun
      "discord"
      #"minecraft"
      "spotify"

      # Productivity
      "itsycal"
      "notion"

      # Sync
      "cryptomator"
      "filen"
      #{
      # name = "filen";
      # args = { appdir = externalAppDir };
      #}
      "syncthing-app"
      #{
      # name = "syncthing-app";
      # args = { appdir = externalAppDir };
      #}

      # System
      "jordanbaird-ice"
      "maccy"
      "stats"

      # Tools
      "bitwarden"
      #{
      # name = "bitwarden";
      # args = { appdir = externalAppDir };
      #}
      #"cemu"
      "gimp"
      #{
      # name = "gimp";
      # args = { appdir = externalAppDir };
      #}
      "keycastr"
      #{
      # name = "keycastr";
      # args = { appdir = externalAppDir };
      #}
      "kicad"
      "obs"
      #{
      # name = "obs";
      # args = { appdir = externalAppDir };
      #}
      "skim"
      "vlc"
      #{
      # name = "vlc";
      # args = { appdir = externalAppDir };
      #}
      "zotero"
      #{
      # name = "zotero";
      # args = { appdir = externalAppDir };
      #}

      # Web
      "firefox"
      "tailscale-app"
      "thunderbird"
      #{
      # name = "ungoogled-chromium";
      # args = { appdir = externalAppDir };
      #}
      "ungoogled-chromium"
    ];

    # Delete unspecified Homebrew formulae
    onActivation.cleanup = "zap";
  };

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

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  nix.settings.experimental-features = "nix-command flakes";
  # Turn nix-darwin from managing the installed version of nix,
  # since Determinate already does.
  nix.enable = false;
  system.stateVersion = 6;
}
