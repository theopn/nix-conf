{ config, pkgs, lib, ... }:

let
  set-wallpaper = pkgs.writeShellScriptBin "set-wallpaper.sh" ''
    if [ -z "$1" ]; then
      echo "Usage: set-wallpaper <image path>"
      exit 1
    fi

    ASSETS_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/theo-niri-assets"
    mkdir -p "$ASSETS_DIR"
    WALLPAPER="$ASSETS_DIR/wallpaper.png"
    LOCKSCREEN="$ASSETS_DIR/lockscreen.png"

    # Back up existing wallpaper
    if [ -f "$WALLPAPER" ]; then
      TIMESTAMP=$(${pkgs.coreutils}/bin/date +%Y-%m-%d-%H-%M-%S)
      cp "$WALLPAPER" "$ASSETS_DIR/wallpaper-$TIMESTAMP.png"
    fi

    # Attempt to change it to PNG
    ${pkgs.imagemagick}/bin/magick "$1" "$WALLPAPER"

    # Generate lockscreen image with imagemagick and Nerdfont lock icon
    ${pkgs.imagemagick}/bin/magick "$WALLPAPER"         \
    -blur 0x8 -fill black -colorize 40%               \
    -font "ProggyClean-Nerd-Font" -pointsize 150 -fill white -gravity center -annotate +0+0 "" \
    "$LOCKSCREEN"

    # Respawn swaybg
    pkill swaybg
    ${pkgs.swaybg}/bin/swaybg --mode fill --image "$WALLPAPER" & disown

    ${pkgs.dunst}/bin/dunstify -a "System" -i "$WALLPAPER" "Wallpaper & lockscreen updated"
  '';
in
lib.mkIf pkgs.stdenv.isLinux {
  home.packages = [ set-wallpaper ];

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      #ignore-empty-password = true;
      show-failed-attempts = true;
      show-keyboard-layout = true;
      scaling = "fill";
      color = "39404F";

      # automatically generated when changing wallpaper with set-wallpaper.sh
      image = "${config.home.homeDirectory}/.local/share/theo-niri-assets/lockscreen.png";
    };
  };
}
