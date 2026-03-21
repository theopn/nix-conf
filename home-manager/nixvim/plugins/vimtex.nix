{ pkgs, ... }:

let
  myTexlive = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      # compilation
      latexmk luatex synctex

      # Your specific document packages
      amsmath amstex amsfonts
      enumitem minted soul hyperref framed
      tcolorbox import xcolor
      geometry titlesec

      forest

      algorithms
      # algpseudocodex dependencies
      algpseudocodex algorithmicx "fifo-stack" varwidth
      kvoptions etoolbox "tabto-ltx" totcount tikzmark

      # font related
      sourcesanspro sourcecodepro sourceserifpro ly1
      fontawesome

      scheme-small;
  };
in
{

  # expose latexmk to the system as well
  home.packages = [ myTexlive ];

  programs.nixvim = {
    plugins.vimtex = {
      zathuraPackage = pkgs.zathura;
      texlivePackage = myTexlive;

      enable = true;

      settings = {
        compiler_method = "latexmk";
        tex_flavor = "latex";

        # --shell-escape allows use of external tools
        # e.g., minted requiring pygmentize
        # apparently not needed in NixOS
        # compiler_latexmk = {
        #   options = [
        #     "-shell-escape"
        #     "-verbose"
        #     "-file-line-error"
        #     "-synctex=1"
        #     "-interaction=nonstopmode"
        #   ];
        # };

        view_method = "general";
      };
    };
  };
}
