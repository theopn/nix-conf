{ pkgs, ... }:

let
  border = "rounded";
  winblend = 0;
in
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [ friendly-snippets ];

    plugins.blink-cmp = {
      enable = true;

      settings = {
        completion = {
          # key|wrd searches "keywrd" instead of just "key" ("prefix")
          keyword.range = "full";
          list.selection = {
            # do not preselect first item
            preselect = false;
            # insert selected item, C-e to discard
            auto_insert = true;
          };

          menu = {
            border = border;
            winblend = winblend;
          };

          draw.padding = 5;

          documentation = {
            auto_show = true;
            auto_show_delay_ms = 50;
            window = {
              border = border;
              winblend = winblend;
            };
          };
        };

        signature = {
          enabled = true;
          window = {
            border = border;
            winblend = winblend;
          };
        };

        sources = {
          default = [ "lsp" "buffer" "snippets" "path" ];
          providers.snippets.opts.friendly-snippets = true;
        };

        keymap = {
          # enter preset gives: (https://cmp.saghen.dev/configuration/keymap.html)
          # C-Spc: trigger
          # C-e: cancel
          # C-y: accept
          # C-n/C-p up/down
          # C-b/C-f: scroll doc
          # C-k signature help
          preset = "enter";

          # how does no preset provides a good tab completion??
          "<Tab>" = [ "snippet_forward" "select_next" "fallback" ];
          "<S-Tab>" = [ "snippet_backward" "select_prev" "fallback" ];
        };

        cmdline.enabled = true;
      };

    };

  };
}
