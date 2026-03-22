{ ... }:

{
  services.copyq = {
    enable = true;
    systemdTarget = "niri.service";
  };
}
