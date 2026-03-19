# other stuff
{ config, pkgs, ... }:

{

  # Packages and services
  fonts.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt
    nerd-fonts.fantasque-sans-mono
    noto-fonts-cjk-sans  # for Korean input
  ];

  programs.firefox.enable = true;
  programs.thunderbird.enable = true;

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

    # Nvim LSP
    tree-sitter bash-language-server
    # order matters since both provides `clangd` command
    clang-tools clang

    gimp vimiv-qt vlc
    libreoffice kicad zotero
    vim
    alacritty
  ];

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
        "vimiv.desktop"
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
