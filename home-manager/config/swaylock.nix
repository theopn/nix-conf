{ config, lib, pkgs, ... }:

let
  theo-set-wallpaper = pkgs.writeShellApplication {
    name = "theo-set-wallpaper";
    runtimeInputs = with pkgs; [ imagemagick swaybg dunst ];
    text = ''
      if [ -z "$1" ]; then
        echo "Usage: theo-set-wallpaper <image path>"
        exit 1
      fi

      ASSETS_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/theo-niri-assets"
      mkdir -p "$ASSETS_DIR"
      WALLPAPER="$ASSETS_DIR/wallpaper.png"
      LOCKSCREEN="$ASSETS_DIR/lockscreen.png"

      # Back up existing wallpaper
      if [ -f "$WALLPAPER" ]; then
        TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
        cp "$WALLPAPER" "$ASSETS_DIR/wallpaper-$TIMESTAMP.png"
      fi

      # Convert to change it to PNG
      magick "$1" "$WALLPAPER"

      # Generate lockscreen image with imagemagick and Nerdfont lock icon
      magick "$WALLPAPER"                       \
      -blur 0x8 -fill black -colorize 40%     \
      -font "ProggyClean-Nerd-Font" -pointsize 180 -fill white -gravity center -annotate +0+0 "" \
      "$LOCKSCREEN"

      # Respawn swaybg (|| true for in case it failed to kill)
      pkill swaybg || true
      swaybg --mode fill --image "$WALLPAPER" > /dev/null 2>&1 & disown

      dunstify -u low -i "$WALLPAPER" "Wallpaper & lockscreen updated"
    '';
  };
in
{
  home.packages = [ theo-set-wallpaper pkgs.swaybg ];

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      # allows fingerprint sensor -> RET to unlock
      ignore-empty-password = false;
      show-failed-attempts = true;
      show-keyboard-layout = true;
      scaling = "fill";
      color = "39404F";

      # automatically generated when changing wallpaper with theo-set-wallpaper
      image = "${config.home.homeDirectory}/.local/share/theo-niri-assets/lockscreen.png";
    };
  };
}
