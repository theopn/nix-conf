{ ... }:
{
  programs.lf = {
    enable = true;
  };

  home.file.".config/lf" = {
    source = ../../lf;
    recursive = true;
  };
}

