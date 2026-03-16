{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tree
    git-filter-repo
    poppler
  ];
}

