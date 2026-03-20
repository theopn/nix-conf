{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zathuraPkgs.zathura_pdf_poppler
  ];

  programs.zathura = {
    enable = true;
    extraConfig = ''
      set selection-clipboard clipboard
      '';
  };
}

