{ ... }:

{
  programs.nixvim = {
    plugins.mini = {
      enable = true;

      modules = {

        pairs = {};

        indentscope = {};

        statusline = {
          use_icons = true;
          set_vim_settings = true;
        };

        starter = {
        # 
          # figlet -f small theovim
          header = ''
                     \/   \/
                     |\__/,|     _
                   _.|o o  |_   ) )
                  -(((---(((--------
                      [ Oliver ]
             _   _                _
            | |_| |_  ___ _____ _(_)_ __
            |  _| ' \/ -_) _ \ V / | '  \
             \__|_||_\___\___/\_/|_|_|_|_|
            '';
        };

      };
    };
  };
}
