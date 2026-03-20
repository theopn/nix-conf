{ pkgs, ... }:
{
  programs.neovide= {
    enable = true;
    settings = {
      frame = if pkgs.stdenv.isDarwin then "transparent" else "full";
      title-hidden = true;
      font = {
        normal = [ "ProggyClean Nerd Font" "FantasqueSansM Nerd Font" "ComicCodeLigatures Nerd Font" ];
        size = 18.0;
        #size = 14.0;
      };
    };
  };
}

