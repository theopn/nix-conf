{ lib, ... }:

{
  services.gammastep = {
    enable = true;
    tray = true;
    temperature = {
      day = 5600;
      night = 3600;
    };
    settings = {
      general = {
        adjustment-method = "wayland";
        gamma-day = 0.9;
        gamma-night = 0.8;
        dawn-time = "08:00";
        dusk-time = "20:00";
      };
    };
  };

  systemd.user.services.gammastep = {
    Install.wantedBy = lib.mkForce [ "niri.service" ];
    Unit.BindsTo = [ "niri.service" ];
    Unit.After = [ "niri.service" ];
  };
}
