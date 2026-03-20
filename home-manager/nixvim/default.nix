{ ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };

  imports = [
    ./opts.nix
    ./autocmds.nix
    ./usercommands.nix
    ./keymaps.nix
    ./plugins/colorschemes.nix
    ./plugins/mini.nix
    # ./plugins/utils.nix
    # ./plugins/git.nix
    # ./plugins/search.nix
    # ./plugins/coding.nix
    # ./plugins/lsp-cmp.nix
  ];
}
