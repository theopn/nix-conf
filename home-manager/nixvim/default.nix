{ ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };


  imports = [
    # defaults
    ./opts.nix
    ./autocmds.nix
    ./usercommands.nix
    ./keymaps.nix

    ./plugins/mini.nix

    # UI
    ./plugins/colorschemes.nix
    ./plugins/web-devicons.nix
    ./plugins/tabby.nix
    ./plugins/colorizer.nix
    ./plugins/todo-comments.nix

    # editing
    ./plugins/lsp.nix
    ./plugins/blink-cmp.nix
    ./plugins/fidget.nix
    ./plugins/treesitter.nix
    ./plugins/gitsigns.nix
    ./plugins/yanky.nix

    # files
    ./plugins/fzf-lua.nix
    ./plugins/oil.nix

    # language-specific
    ./plugins/orgmode.nix
    ./plugins/render-markdown.nix
    ./plugins/vimtex.nix
  ];
}
