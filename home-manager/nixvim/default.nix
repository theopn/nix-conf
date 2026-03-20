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

    # UI
    ./plugins/colorschemes.nix
    ./plugins/mini.nix
    ./plugins/tabby.nix

    ./plugins/fzf-lua.nix
    ./plugins/gitsigns.nix
  ];
}
