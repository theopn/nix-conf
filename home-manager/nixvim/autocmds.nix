{ ... }:

{
  programs.nixvim = {
    autoCmd = [

      # file specific autocmds
      {
        event = "FileType";
        pattern = [ "c" "cpp" ];
        callback.__raw = ''
          function()
            vim.cmd([[
              setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
              setlocal colorcolumn=80 textwidth=79
              setlocal matchpairs+==:;
              command! -buffer RunC !gcc %:p -Wall -Werror -std=c17 -o %:p:r && %:p:r
              command! -buffer RunCpp !g++ %:p -Wall -Werror -std=c++11 -o %:p:r && %:p:r
            ]])
          end
        '';
      }

    ];
  };
}
