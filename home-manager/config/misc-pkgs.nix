{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tree
    git-filter-repo
    poppler-utils
    exiftool
    openconnect
    stow
    ffmpeg
    imagemagick
    #tmux
    hugo
    figlet
    wget
    qemu

    zathuraPkgs.zathura_pdf_poppler
    (texlive.combine {
     inherit (pkgs.texlive)
     scheme-small

     # compilation
     latexmk
     luatex
     synctex

     amsmath
     amstex
     amsfonts
     enumitem
     minted
     soul
     hyperref
     framed
     tcolorbox
     import
     forest

     # algpseudocodex dependencies (except algorithms)
     algorithms
     algpseudocodex
     algorithmicx
     fifo-stack
     varwidth
     kvoptions
     etoolbox
     tabto-ltx
     totcount
     tikzmark

     # font related
     sourcesanspro
     sourcecodepro
     sourceserifpro
     ly1
     ;
     })

  ];
}

