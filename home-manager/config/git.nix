{ pkgs, ... }:
{
  home.packages = with pkgs; [ git-filter-repo ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name  = "Theo P.";
        email = "theo.park.n@gmail.com";
      };
      core ={
#excludesfile = ~/.gitignore_global;
        editor = "nvim";
        pager = "nvim -R +'set nomodifiable noswapfile nocursorcolumn nonumber norelativenumber scrolloff=999' +'set ft=git' -";
        autocrlf = "input";
      };
# delete outdated branches during fetch
      fetch.prune = true;
      init.defaultBranch = "main";
      status.short = true;
      https.postbuffer = 157286400;
      submodule.recurse = true;
      push.recurseSubmodules = "on-demand";
    };

    ignores =[
      ".DS_Store"
        ".idea/"
        "*.xml"
        "*.iml"
        "*.class"
        "./auto/*"
        "*~"
        "npm-debug.log"
        "*.aux"
        "*.lof"
        "*.log"
        "*.lot"
        "*.fls"
        "*.out"
        "*.toc"
        "*.fmt"
        "*.fot"
        "*.cb"
        "*.cb2"
        ".*.lb"
        "*fdb_latexmk"
        "*.synctex.gz"
        "latex.out/"
        "_minted/"
        "*.bbl"
        "*.bcf"
        "*.blg"
        "*-blx.aux"
        "*-blx.bib"
        "*.run.xml"
    ];
  };
}

