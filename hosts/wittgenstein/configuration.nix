{ config, lib, pkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
      ./idkwhattoname.nix
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

  services.tailscale.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
    systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];


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


  # Minimal GNOME
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-calculator gnome-clocks simple-scan snapshot gnome-characters
    # Totem = video, loupe = image, evince = PDF
    gnome-music evince gnome-font-viewer # totem loupe
    # baobab = disk usage
    baobab gnome-disk-utility gnome-system-monitor gnome-logs gnome-connections
    # geary = email
    geary gnome-contacts gnome-calendar gnome-weather gnome-maps
    # yelp = help
    gnome-text-editor yelp gnome-tour gnome-usage gnome-terminal gnome-console
    # cheese = camera, epiphany = browser
    cheese epiphany
  ];


  # Me
  programs.zsh.enable = true;
  users.users.theopn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    shell = pkgs.zsh;
  };


  # Environment variables
  environment.localBinInPath = true;  # add ~/.local/bin to $PATH
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    LESSHISTFILE = "-";
  };


  # Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; # Did you read the comment?
}

