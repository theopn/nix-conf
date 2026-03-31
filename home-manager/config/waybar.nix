{ lib, pkgs, ... }:

let
  # scripts in https://github.com/theopn/haunted-tiles/tree/niri
  theo-rofi-niri-workspace-rename = pkgs.writeShellApplication {
    name = "theo-rofi-niri-workspace-rename";
    runtimeInputs = with pkgs; [ rofi ];
    text = ''
      rename='󰑕 rename'
      reset='󰬟 reset'
      cancel='󰜺 cancel'
      function run_rofi_selection() {
        echo -e "$rename\n$reset\n$cancel" | rofi -dmenu -p ">" -mesg "Changing Current Workspace Name"
      }
      function get_name() {
        echo "" | rofi -dmenu -p "Enter Workspace Name:" -l 0
      }
      function main() {
        chosen="$(run_rofi_selection)"
        case $chosen in
          "$rename") niri msg action set-workspace-name "$(get_name)" ;;
          "$reset")  niri msg action unset-workspace-name ;;
        esac
      }
      main
    '';
  };

  theo-rofi-dnd = pkgs.writeShellApplication {
    name = "theo-rofi-dnd";
    runtimeInputs = with pkgs; [ rofi dunst ];
    text = ''
      on_action=' Pause Notification'
      off_action=' Resume Notification'

      current=' You are being disturbed'
      toggle="$on_action"
      if [[ $(dunstctl is-paused) == 'true' ]]; then
        current=" You are missing out on $(dunstctl count waiting) notifications"
        toggle="$off_action"
      fi

      action=$(echo -e "$toggle" | rofi -dmenu \
        -theme-str 'window {height: 150px; width: 400px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -mesg "$current")

      if [[ "$action" == "$on_action" ]]; then
        dunstctl set-paused true
      elif [[ "$action" == "$off_action" ]]; then
        dunstctl set-paused false
      fi
    '';
  };

  theo-rofi-dunst-manager = pkgs.writeShellScriptBin "theo-rofi-dunst-manager" ''
    function replace_special_char() {
      # replace & < > since Rofi throws Pango error with them
      echo "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
    }

    function get_notif_list() {
      local uptime=$(awk '{print $1}' /proc/uptime)

      echo "$HIST_JSON" | jq -r --arg uptime "$uptime" '
      .data[0][] |
        (($uptime | tonumber) - (.timestamp.data / 1000000)) as $age |
        (
          if $age < 60 then "\($age | floor)s"
          elif $age < 3600 then "\($age / 60 | floor)m"
          elif $age < 86400 then "\($age / 3600 | floor)h"
          else "\($age / 86400 | floor)d"
          end
        )
        as $time |
          "<span size=\"small\">[\($time)]</span> <b>\(.appname.data | @html)</b>: \(.summary.data | gsub("\n"; " ") | @html)"
      '
    }

    function set_shell_var() {
      echo "$HIST_JSON" | jq -r --argjson idx "$1" '
      .data[0][$idx] |
        "ID=\(.id.data) APP=\(.appname.data | @sh) SUMMARY=\(.summary.data | @sh) BODY=\(.body.data | @sh) URGENCY=\(.urgency.data | @sh)"
      '
    }

    function warn_dunst_duplicate_id() {
      echo -e "gotcha\nback" | rofi -dmenu  --markup-rows           \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}'               \
        -theme-str 'textbox {horizontal-align: 0.5;}'               \
        -theme-str 'element-text {horizontal-align: 0.5;}'          \
        -mesg '[FYI] Dunst will pick the <i>oldest</i> notification with the same ID, which might not be this one.'
    }

    while true; do
      HIST_JSON=$(dunstctl history)

      # -format i to return index as an output instead of str
      # -i for case insensitivity
      idx=$(get_notif_list | rofi -dmenu -p "History>" -markup-rows -format i -i  \
        -mesg "<span size=\"small\">ESC to quit</span>"     \
        -theme-str 'window {height: 800px; width: 800px;}'  \
        -theme-str 'listview {columns: 1;}'                 \
        -theme-str 'textbox {horizontal-align: 0.5;}'       \
      )
      # Exit if no selection
      [[ -z "$idx" ]] && exit 0

      # set variables with jq
      eval $(set_shell_var "$idx")

      msg="<b>App:</b> $(replace_special_char "$APP")
    <b>ID:</b> "$ID" | <b>Urgency:</b> "$URGENCY"
    <b>Summary:</b> $(replace_special_char "$SUMMARY")
    $(replace_special_char "$BODY")
      "
      action=$(echo -e "back\ndelete\ndisplay" | rofi -dmenu -p ">" \
        -mesg "$msg" \
        -markup-rows \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 3; lines: 1;}'               \
    )

      if [[ -z "$action" ]]; then
        exit 0
      elif [[ "$action" == "delete" ]]; then
        warn_confirm=$(warn_dunst_duplicate_id)
        [[ "$warn_confirm" == "gotcha" ]] && dunstctl history-rm "$ID"
      elif [[ "$action" == "display" ]]; then
        warn_confirm=$(warn_dunst_duplicate_id)
        [[ "$warn_confirm" == "gotcha" ]] && dunstctl history-pop "$ID"
      fi

    done
  '';
in
{
  programs.waybar = {
    enable = true;

    # make sure to launch niri with `niri-session` command
    systemd = {
      enable = true;
      targets = [ "niri.service" ];
    };


    settings = {
      mainBar = {
        id = "theo-waybar-niri";
        layer = "top";
        position = "top";
        height = 34;
        spacing = 1;

        modules-left= [
          "niri/workspaces"
          "custom/niri-workspace-rename"
          "niri/window"
        ];
        modules-center = [
          "custom/dunst"
          "clock"
        ];
        modules-right = [
          "cpu"
          "temperature"
          "memory"
          "mpris"
          "pulseaudio"
          "backlight"
          "battery"
          "power-profiles-daemon"
          "idle_inhibitor"
          "keyboard-state"
          "custom/separator"
          "tray"
        ];

        # modules-left
        "niri/workspaces" = {
          format = "{index}:{name}";
          format-icons = {
            default = "";
            productivity = " ";
            dev = " ";
            browser = " ";
            social = " ";
          };
        };

        "custom/niri-workspace-rename" = {
          format = "󰑕 ";
          tooltip = true;
          tooltip-format = "Rename Current Workspace";
          on-click = "${lib.getExe theo-rofi-niri-workspace-rename}";
        };

        "niri/window" = {
          format = "{title}";
          max-length = 50;
          icon = true;
          swap-icon-label = false;
        };

        # modules-center
        "custom/dunst" = {
          format = "󰵛";
          tooltip = true;
          tooltip-format = "L: DND Manager / R: History Manager";
          on-click = "${lib.getExe theo-rofi-dnd}";
          on-click-right = "${lib.getExe theo-rofi-dunst-manager}";
        };

        clock = {
          format = "  {:%b %e %H:%M}";

          tooltip-format = "\t<big>{:%H:%M:%S}</big>\n\n<tt><small>{calendar}</small></tt>";

          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "left";
            on-click-right = "mode";
            iso-8601 = true;
            format = {
              weeks = "<span color='#d8dee9'><i>{}</i></span>";
              today = "<span color='#b48ead'><b><u>{}</u></b></span>";
            };
          };

          actions.on-click-right = "mode";
        };

        # modules-right
        cpu = {
          interval = 15;
          format = "{icon} {usage}%";
          format-icons = "";
          tooltip = false;
        };

        memory = {
          interval = 15;
          format = "{icon} {percentage}%";
          format-icons = "";
          tooltip-format = "{used} used out of {total}";
        };

        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = "";
        };

        mpris = {
          format = "{status_icon} {player_icon}";
          format-paused = "<s>{status_icon} {player_icon}</s>";
          on-click-middle = "";
          on-click-right = "";
          player-icons = {
            default = " ";
            firefox = " ";
            spotify = " ";
            chromium = " ";
            plasma-browser-integration = "󰾔 ";
            mpv = " ";
          };
          status-icons = {
            playing = "";
            paused = "";
          };
          max-length = 10;
        };

        pulseaudio = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "󰗾 ({icon}) {volume}% {format_source}";
          format-bluetooth-muted = "󰗿 ({icon}) {format_source}";
          format-muted = "󰝟 {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = " ";
            hands-free = "󱡒 ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [" " " " " " " " " " " " " " " " " "];
        };

        battery = {
          bat = "BAT1";
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰃨 {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [" " " " " " " " " "];
          tooltip-format = "{timeTo}";
          interval = 30;
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = " ";
            performance = " ";
            balanced = " ";
            power-saver = " ";
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶 ";
            deactivated = "󰾪 ";
          };
          tooltip-format-activated = "CAFFEINATED";
          tooltip-format-deactivated = "might fall asleep";
        };

        keyboard-state = {
          numlock = false;
          capslock = true;
          scrolllock = false;
          format = {
            numlock = "N {icon}";
            capslock = "{icon}";
          };
          format-icons = {
            locked = "󰪛 ";
            unlocked = "";
          };
          binding-keys = [ 29 69 70 ];
        };

        "custom/separator" = {
          format = "";
          tooltip = false;
          interval = "once";
        };

        tray = {
          icon-size = 20;
          spacing = 10;
        };
      };
    };

    style = ''
    /*
    * _      __          __              ______       __
    *| | /| / /__ ___ __/ /  ___ _____  / __/ /___ __/ /__
    *| |/ |/ / _ `/ // / _ \/ _ `/ __/ _\ \/ __/ // / / -_)
    *|__/|__/\_,_/\_, /_.__/\_,_/_/   /___/\__/\_, /_/\__/
    *            /___/                        /___/
    */

    /* Nord Color Palette */
    @define-color color00 #2e3440;
    @define-color color01 #3b4252;
    @define-color color02 #434c5e;
    @define-color color03 #4c566a;
    @define-color color04 #d8dee9;
    @define-color color05 #e5e9f0;
    @define-color color06 #eceff4;
    @define-color color07 #8fbcbb;
    @define-color color08 #88c0d0;
    @define-color color09 #81a1c1;
    @define-color color10 #5e81ac;
    @define-color color11 #bf616a;
    @define-color color12 #d08770;
    @define-color color13 #ebcb8b;
    @define-color color14 #a3be8c;
    @define-color color15 #ba8baf;

    * {
      font-family: "ProggyClean Nerd Font";
      font-size: 18px;
      border-radius: 12px;
    }

    window#waybar {
      margin: 10px 10px;
      background: rgba(46, 52, 64, 0.7);  /* @color00 */
      color: @color06;
    }


    /* Modules - Left */

    #workspaces {
      padding: 3px 3px;
    }

    #workspaces button {
      padding: 0px 9px 0px 9px;
      min-width: 1px;
    }

    #workspaces button.focused {
      color: @color00;
      background-color: @color06;
    }

    #workspaces button.urgent {
      background-color: @color11;
    }

    #custom-niri-workspace-rename {
      color: @color07;
      padding: 0px 1px 0px 1px;
    }

    #window {
      padding: 0px 10px 0px 10px;
      margin : 3px 3px;
    }

    window#waybar.empty #window {
      background-color: transparent;
      color: transparent;
    }


    /* Modules - Center */


    #custom-dunst {
      color: @color08;
      padding: 0px 5px;
      margin : 3px 3px;
    }

    #clock {
      padding: 0 5px;
      margin : 3px 3px;
    }


    /* Modules - Right */

    #disk, #temperature, #cpu, #memory, #network,
    #mpris, #pulseaudio,
    #backlight, #battery, #power-profiles-daemon, #idle_inhibitor,
    #tray
    {
      margin: 1px 1px;
      padding: 0 5px;
    }

    #mpris.playing{
      background-color: @color13;
    }

    #pulseaudio.muted {
      color: @color07
    }

    #battery.warning, #battery.critical {
      color: @color12;
    }

    #battery.charging, #battery.plugged {
      background-color: @color11;
    }

    #power-profiles-daemon {
      color: @color07;
    }

    #power-profiles-daemon.performance {
      background-color: @color11;
    }

    #power-profiles-daemon.power-saver {
      color: @color14;
    }

    #idle_inhibitor {
      color: @color07;
    }

    #idle_inhibitor.activated{
      background-color: @color11;
    }

    #keyboard-state label.locked {
      padding: 0 5px;
      color: @color14;
    }


    /* Tray */

    #custom-seperator {
      color: @color06;
      padding: 1px 1px;
    }

    #tray > .passive {
      -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
      background-color: @color11;
    }
    '';
  };
}
