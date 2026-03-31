{ pkgs, ... }:

{
  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];

    systemdTargets = [ "niri.service" ];

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
