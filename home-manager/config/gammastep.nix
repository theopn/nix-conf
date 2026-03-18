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

  # Manually trigger in Niri config, since systemd service completely breaks Gnome
  systemd.user.services.gammastep.Install.WantedBy = lib.mkForce [ ];
  systemd.user.services.gammastep-indicator.Install.WantedBy = lib.mkForce [ ];
}
