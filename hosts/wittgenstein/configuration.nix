{ config, lib, pkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
    ];

  # Boot settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking & time
  networking.hostName = "wittgenstein";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Minimal GNOME
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    cheese epiphany evince geary totem
    tali iagno hitori atomix yelp
    gnome-tour gnome-maps gnome-logs gnome-usage
    gnome-music gnome-console gnome-terminal gnome-contacts
    gnome-calendar gnome-weather gnome-text-editor
  ];
  programs.niri.enable = true;

  # Hardware services
  services.fwupd.enable = true;
  services.fprintd.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;
  # https://knowledgebase.frame.work/optimizing-fedora-battery-life-r1baXZh
  services.tuned.enable = true;
  services.tlp.enable = false;
  services.upower.enable = true;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.libinput = {
    enable = true;
    touchpad.tapping = true;
    touchpad.naturalScrolling = true;
  };

  # Other services
  services.openssh.enable = true;

  # User
  programs.zsh.enable = true;
  users.users.theopn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    shell = pkgs.zsh;
  };

  # System packages
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    curl wget gcc gdb git killall
    gnumake zip unzip file jq
    vim
    alacritty
  ];

  # Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; # Did you read the comment?

}

