{
  flake.modules.homeManager.xdg-mime = {
    # to get application names installed through nixOS and home-manager, use:
    # ls -l /run/current-system/sw/share/applications/ /etc/profiles/per-user/${USER}/share/applications/
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/xhtml+xml"    = [ "librewolf.desktop" "firefox.desktop" ];
        "x-scheme-handler/http"    = [ "librewolf.desktop" "firefox.desktop" ];
        "x-scheme-handler/https"   = [ "librewolf.desktop" "firefox.desktop" ];
        "x-scheme-handler/about"   = [ "librewolf.desktop" "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "librewolf.desktop" "firefox.desktop" ];
        "x-scheme-handler/mailto"  = "thunderbird.desktop";

        "image/*" = [ "imv-dir.desktop" "gimp.desktop" ];
        "video/*" = "mpv.desktop";
        "audio/*" = "mpv.desktop";

        "application/pdf"      = "org.pwmt.zathura.desktop";
        "application/epub+zip" = "org.pwmt.zathura.desktop";

        "text/*"    = "neovide.desktop";
        # thank you wonderful people at home-manager for incorporating my comment
        # https://github.com/nix-community/home-manager/issues/8752#issuecomment-5371950044
        "text/html" = [ "librewolf.desktop" "firefox.desktop" ];

        "inode/directory" = "lf.desktop";
      };
    };
  };
}
