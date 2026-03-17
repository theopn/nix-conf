# Stuff
{ config, pkgs, ... }:
let
  # Fetch relatively new brightnessctl since the old one doesn't support -get flag
  # https://github.com/hummer12007/brightnessctl/issues/90
  newBrightnessctl = pkgs.brightnessctl.overrideAttrs (old: {
    version = "git";
    src = pkgs.fetchFromGitHub {
      owner = "Hummer12007";
      repo = "brightnessctl";
      rev = "e70bc55cf053caa285695ac77507e009b5508ee3";
      sha256 = "sha256-agteP/YPlTlH8RwJ9P08pwVYY+xbHApv9CpUKL4K0U0=";
    };
    postPatch = ''
      substituteInPlace configure \
        --replace-fail "pkg-config" "$PKG_CONFIG"

      substituteInPlace 90-brightnessctl.rules \
        --replace-fail /bin/ ${pkgs.coreutils}/bin/
    '';
    configurePhase = "./configure --enable-logind";
  });
in
{

  # Packages and services
  fonts.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt
    nerd-fonts.fantasque-sans-mono
    noto-fonts-cjk-sans  # for Korean input
  ];

  programs.firefox.enable = true;
  programs.thunderbird.enable = true;

  services.tailscale.enable = true;
  services.syncthing = {
    enable = true;
    user = "theopn";
    dataDir = "/home/theopn/Sync";
    configDir = "/home/theopn/.config/syncthing";

    overrideDevices = false;
    overrideFolders = false;
  };

  environment.systemPackages = with pkgs; [
    # paying the price for doing the minimal install
    curl wget gcc gdb git killall
    gnumake zip unzip file jq

    # Propritery apps
    chromium discord slack spotify zoom-us

    # Niri related
    xwayland-satellite
    dunst rofi swaybg swaylock swayidle waybar
    copyq pavucontrol playerctl gammastep networkmanagerapplet
    grim slurp sway-contrib.grimshot wf-recorder wl-clipboard-rs
    newBrightnessctl #brightnessctl

    # Nvim LSP
    tree-sitter bash-language-server
    # order matters since both provides `clangd` command
    clang-tools clang

    vlc gimp
    kicad
    vim
    alacritty
  ];

  # Niri & Portal
  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = [ "gnome" "gtk" ];
  };

  # default applications
  # ls -l /run/current-system/sw/share/applications/ /etc/profiles/per-user/${USER}/share/applications/
  xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "application/xhtm+xml" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";

      "application/pdf" = "org.pwmt.zathura.desktop";

      "text/*" = "neovide.desktop";

      "video/*" = "vlc.desktop";

      "image/*" = [
        "org.gnome.Loupe.desktop"
        "gimp.desktop"
      ];

      "inode/directory" = "lf.desktop";
  };

  # fcitx5
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      ignoreUserConfig = true;
      addons = with pkgs; [ fcitx5-hangul ];
      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "hangul";
        };
      };
    };
  };


}
