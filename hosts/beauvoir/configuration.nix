{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.bat
    pkgs.btop
    pkgs.fastfetch
    pkgs.lf
    pkgs.neovim
    pkgs.fish
  ];

  users.users.theopn = {
    name = "theopn";
    home = "/Users/theopn";
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
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}
      #"intellij-idea"
      "kitty"
      "mactex-no-gui"
      "macvim-app"
      "neovide-app"
      #"rstudio"
      "wezterm"

      # Fun
      "discord"
      #{
      # name = "discord";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}
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
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}
      "syncthing-app"
      #{
      # name = "syncthing-app";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}

      # System
      "jordanbaird-ice"
      "maccy"
      "stats"

      # Tools
      "bitwarden"
      #{
      # name = "bitwarden";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}
      #"cemu"
      "gimp"
      #{
      # name = "gimp";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}
      "keycastr"
      #{
      # name = "keycastr";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}
      "kicad"
      "obs"
      #{
      # name = "obs";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}
      "skim"
      "vlc"
      #{
      # name = "vlc";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}
      "zotero"
      #{
      # name = "zotero";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
      #}

      # Web
      "firefox"
      "tailscale-app"
      "thunderbird"
      #{
      # name = "ungoogled-chromium";
      # args = { appdir = "/Volumes/theo-crucial-p310/Applications" };
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
