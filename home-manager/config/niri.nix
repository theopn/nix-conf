{ pkgs, ... }:

let
  theo-rofi-powermenu = pkgs.writeShellApplication {
    name = "theo-rofi-powermenu";
    runtimeInputs = with pkgs; [ rofi ];
    text = ''
      shutdown='   shutdown'
      reboot=' 󰜉  reboot'
      lock='   lock'
      suspend=' 󰤄  suspend'
      logout=' 󰗼  logout'
      yes='   yes'
      no=' 󰜺  no'

      shutdown_cmd='systemctl poweroff'
      suspend_cmd='systemctl suspend'
      reboot_cmd='systemctl reboot'
      lock_cmd='swaylock -f'
      exit_wm_cmd='niri msg action quit'

      function run_rofi_selection() {
        echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi -dmenu  \
            -p "󰐦 "                                                           \
            -mesg "Uptime: $(uptime)"
      }

      function run_rofi_confirmation() {
        echo -e "$yes\n$no" | rofi  \
          -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
          -theme-str 'mainbox {children: [ "message", "listview" ];}' \
          -theme-str 'listview {columns: 2; lines: 1;}' \
          -theme-str 'element-text {horizontal-align: 0.5;}' \
          -theme-str 'textbox {horizontal-align: 0.5;}' \
          -dmenu \
          -p 'Confirmation' \
          -mesg 'Are you Sure?'
      }

      function confirm_then_run() {
        selected="$(run_rofi_confirmation)"
        if [[ "$selected" == "$yes" ]]; then
          if [[ $1 == '--shutdown' ]]; then
            $shutdown_cmd
          elif [[ $1 == '--reboot' ]]; then
            $reboot_cmd
          elif [[ $1 == '--logout' ]]; then
            $exit_wm_cmd
          fi
        else
          exit 0
        fi
      }

      function main() {
        chosen="$(run_rofi_selection)"
        case $chosen in
          "$lock") $lock_cmd ;;
          "$shutdown") confirm_then_run --shutdown ;;
          "$reboot") confirm_then_run --reboot ;;
          "$suspend") $suspend_cmd ;;
          "$logout") confirm_then_run --logout ;;
        esac
      }
      main
    '';
  };

  theo-rofi-screenshot = pkgs.writeShellApplication {
    name = "theo-rofi-screenshot";
    runtimeInputs = with pkgs; [ rofi grim sway-contrib.grimshot ];
    text = ''
      area_cp=' area (clipboard)'
      area='󰩭 area'
      screen='󰹑 screen'

      function run_rofi_selection() {
        echo -e "$area_cp\n$area\n$screen" | rofi -dmenu -p "Screenshot Type>" -mesg "Path: ~/Pictures"
      }

      # window does not work in Niri, I do not know which package provides ppm in NixOS
      function main() {
        chosen="$(run_rofi_selection)"
        case $chosen in
          "$area_cp") grimshot --notify copy area ;;
          "$area")    grimshot --notify save area ;;
          #"$window")  grimshot --notify save window ;;
          "$screen")  grimshot --notify save screen ;;
          #"$color")   notify-send "$(grim -g "$(slurp -p)" -t ppm - | magick - -format '%[pixel:p{0,0}]' txt:-)" ;;
        esac
      }
      main
    '';
  };

  theo-rofi-screenrecord = pkgs.writeShellApplication {
    name = "theo-rofi-screenrecord";
    runtimeInputs = with pkgs; [ rofi wf-recorder killall ];
    text = ''
      #!/usr/bin/env bash

      # Options
      stop='     stop recording'
      area='󰩭 +  area (no audio)'
      screen='󰹑 +  screen (no audio)'
      screen_audio='󰹑 +  screen with audio'

      function run_rofi_selection() {
        echo -e "$stop\n$area\n$screen\n$screen_audio" | rofi -dmenu -p "Screen Recording Action>"
      }

      function main() {
        chosen="$(run_rofi_selection)"
        out="$HOME/Pictures/record-$(date +'%Y-%m-%d--%H-%M-%S.mp4')"
        case "$chosen" in
          "$stop")          killall -s SIGINT wf-recorder && dunstify '[Screenrecorder] SIGINT sent!' ;;
          "$area")          wf-recorder -f "$out" -g "$(slurp)" ;;
          "$screen")        wf-recorder -f "$out" ;;
          "$screen_audio")  wf-recorder --audio -f "$out" ;;
        esac
      }

      main
    '';
  };
in
{

  home.packages = with pkgs; [
    theo-rofi-powermenu theo-rofi-screenshot theo-rofi-screenrecord
    brightnessctl pavucontrol playerctl
    grim slurp sway-contrib.grimshot wf-recorder wl-clipboard-rs
    nautilus networkmanagerapplet pantheon.pantheon-agent-polkit
    xwayland-satellite
  ];

  # !!!!! IMPORTANT !!!!!
  # Since there is no home-manager module for Niri yet,
  # programs.niri.enable is in configuration.nix
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = [ "gnome" "gtk" ];
  };

  services.gnome-keyring = {
    enable = true;
    # SSH key managed with keychain in my system
    components = [ "secrets" ];
  };

}
