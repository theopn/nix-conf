{ ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };

  imports = [
    ./opts.nix
    ./autocmds.nix
    # ./keymaps.nix
    # ./plugins/ui.nix
    # ./plugins/utils.nix
    # ./plugins/git.nix
    # ./plugins/search.nix
    # ./plugins/coding.nix
    # ./plugins/lsp-cmp.nix
  ];
}
