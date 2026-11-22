{
  flake.modules.nixos.localsend = { ... }: {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };

    # not necessary as localsend module handles it
    # networking.firewall = {
    #   allowedTCPPorts = [ 53317 ];
    #   allowedUDPPorts = [ 53317 ];
    # };
  };
}

