{ ... }:

{
  services.udiskie = {
    enable = true;
    automount = false;
    notify = true;
    tray = "auto";
  };
}
