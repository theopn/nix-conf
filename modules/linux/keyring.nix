{
  flake.modules.nixos.keyring = {
    security.pam.services.login.enableGnomeKeyring = true;
  };

  flake.modules.homeManager.keyring = {
    # messing with pam breaks the login keyring for whatever reason
    # just delete ~/.local/share/keyrings/login.keyring
    # and create a new keyring named "Default Keyring" with Seahorse
    services.gnome-keyring = {
      enable = true;
      # SSH keys are managed with `keychain` so no need for that
      components = [ "secrets" ];
    };
  };
}
