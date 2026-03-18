{ pkgs, ... }:

{
  services.swayidle = {
    enable = true;

    extraArgs = [ "-w" ];

    # disable systemd service (for Gnome) by binding to no target.
    # well so I thought, now launching Swayidle with Niri doesn't work,
    # so I guess I will deal with some journalctl logs
    #systemdTarget = "";

    events = {
      "before-sleep" = "${pkgs.swaylock}/bin/swaylock -f";
    };

    timeouts = [
      {
        timeout = 180;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 420;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        timeout = 540;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
