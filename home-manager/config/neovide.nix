{ ... }:
{
  programs.neovide= {
    enable = true;
    settings = {
      #frame = "transparent";
      title-hidden = true;
      font = {
        normal = [ "ProggyClean Nerd Font" "FantasqueSansM Nerd Font" "ComicCodeLigatures Nerd Font" ];
        size = 18.0;
        #size = 14.0;
      };
    };
  };
}

