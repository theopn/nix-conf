{ ... }:
{
  programs.aerospace = {
    enable = true;
  };

  home.file.".aerospace.toml".source = ../../aerospace/.aerospace.toml;
}

