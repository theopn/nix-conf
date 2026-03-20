{
  programs.nixvim = {
    diagnostics = {
      virtual_text = true;
      virtual_lines = { current_line = true; };
      float = { border = "rounded"; };
      underline = true;
      update_in_insert = false;
    };

    plugins.lsp = {
      enable = true;

      servers = {
        bashls.enable = true;
        clangd.enable = true;
        lua_ls.enable = true;
        nixd.enable = true;
        pylsp.enable = true;
        texlab.enable = true;
      };

      keymaps = {
        diagnostic = {
          "<leader>q" = "setloclist";
        };

        lspBuf = {
          "<leader>f" = "format";
        };

        extra = [
          { mode = "n"; key = "gra"; action = "<cmd>FzfLua lsp_code_actions<CR>"; options.desc = "[G]oto Code [A]ctions"; }
          { mode = "n"; key = "grr"; action = "<cmd>FzfLua lsp_references<CR>"; options.desc = "[G]oto [R]eferences"; }
          { mode = "n"; key = "gri"; action = "<cmd>FzfLua lsp_implementations<CR>"; options.desc = "[G]oto [I]mplementation"; }
          { mode = "n"; key = "gO"; action = "<cmd>FzfLua lsp_document_symbols<CR>"; options.desc = "[O]pen Document Symbols"; }
          { mode = "n"; key = "<leader>sd"; action = "<cmd>FzfLua diagnostics_document<CR>"; options.desc = "[S]earch [D]iagnostics"; }
        ];
      };

      # Injected directly into the LspAttach autocmd
      onAttach = ''
        -- document highlight from kickstart.nvim
        local client = vim.lsp.get_client_by_id(client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
          local hl_group = vim.api.nvim_create_augroup("TheovimLspHl", { clear = false })

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = hl_group,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = hl_group,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("TheovimLspHlDetach", { clear = true }),
            callback = function(event)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "TheovimLspHl", buffer = event.buf })
            end
          })
        end
      '';
    };

    extraConfigLua = ''
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
    '';

    userCommands = {
      LspInfo = {
        desc = "Wrapper for :checkhealth vim.lsp";
        command = "checkhealth vim.lsp";
      };
      LspDisable = {
        desc = "Disable all LSP servers in the buffer";
        command = "lua vim.lsp.stop_client(vim.lsp.get_clients())";
      };
    };

  };
}
