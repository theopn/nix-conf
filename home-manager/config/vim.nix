{ ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = false;

    extraConfig = builtins.readFile ./vim/.vimrc;
  };
}
