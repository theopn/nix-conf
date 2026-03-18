{ pkgs, config, ... }:

let
  theo-brightness-ctrl = pkgs.writeShellApplication{
    name = "theo-brightness-ctrl";
    runtimeInputs = with pkgs; [ brightnessctl dunst ];
    text = ''
      bar_color="#FFFFFC"

      # brightnessctl get --percentage is only avilable in Git version,
      # and they haven't done a release since 2024...
      function get_brightness() {
        max=$(brightnessctl max)
        current=$(brightnessctl get)
        echo $(( (current * 100 + max / 2) / max ))
      }

      function show_brightness_notif() {
        brightness=$(get_brightness)
        if [[ "$brightness" -le 25 ]]; then
          icon="󰃞 "
        elif [[ "$brightness" -le 50 ]]; then
          icon="󰃟 "
        elif [[ "$brightness" -le 75 ]]; then
          icon="󰃝 "
        else
          icon="󰃠 "
        fi

        dunstify --timeout=1000 --replace=696969 -u low         \
          "$icon Brightness: $brightness%"                      \
          -h int:value:"''${brightness}" -h string:hlcolor:"''${bar_color}"

      }

      case $1 in
        up)   brightnessctl set +5% ;;
        down) brightnessctl set 5%- ;;
        *)    echo "No argument specified" ;;
      esac

      show_brightness_notif
  '';
  };

  theo-volume-ctrl = pkgs.writeShellApplication {
    name = "theo-volume-ctrl";
    runtimeInputs = with pkgs; [ brightnessctl dunst ];
    text = ''
      bar_color="#FFFFFF"
      function get_volume() {
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
      }
      function get_mute() {
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print ($3 == "[MUTED]" ? "yes" : "no")}'
      }
      function show_volume_notif() {
        volume=$(get_volume)
        mute=$(get_mute)
        if [[ $volume -eq 0 ]] || [[ $mute == "yes" ]] ; then
          volume_icon="󰖁  MUTED"
        elif [[ $volume -lt 50 ]]; then
          volume_icon="󰖀 "
        else
          volume_icon="󰕾 "
        fi
        dunstify --timeout=1000 --replace=6969 -u low         \
          "$volume_icon Volume: ''${volume}%"                 \
          -h int:value:"''${volume}" -h string:hlcolor:"''${bar_color}"
      }
      case $1 in
        up)   wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ ;;
        down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
        mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        *)    echo "No argument specified" ;;
      esac
      show_volume_notif
    '';
  };

  theo-rofi-powermenu= pkgs.writeShellApplication {
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
in
{
  programs.niri.enable = true;

  services.gnome.gnome-keyring.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = [ "gnome" "gtk" ];
  };

  environment.systemPackages = with pkgs; [
    theo-brightness-ctrl theo-volume-ctrl theo-rofi-powermenu
    brightnessctl pavucontrol playerctl
    grim slurp sway-contrib.grimshot wf-recorder wl-clipboard-rs
    networkmanagerapplet
    xwayland-satellite
  ];

  # below are all handled in Home-maanager
  #xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
  #environment.systemPackages = with pkgs; [
  #  copyq dunst gammastep rofi swayidle swaylock waybar
  #];
}
