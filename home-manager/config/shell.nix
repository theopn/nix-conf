{ config, pkgs, lib, ... }:
{
  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    LESSHISTFILE = "-";
    DOT_DIR = "${config.home.homeDirectory}/dotfiles";
    THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
    THEOSHELL_CDF_DIR = "${config.xdg.dataHome}/theoshell/cd-fav.txt";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # enableFishIntegration = true;

    settings = {
      add_newline = false;
      format = "$vi_mode$directory([ $git_branch$git_status ](bg:blue fg:black))$character";
      vi_mode = {
        disabled = false;
        format = "$symbol";
        insert_symbol = "[ I ](bg:green fg:black)";
        normal_symbol = "[ N ](bg:cyan fg:black)";
      };
      directory = {
        format = "[ $path ]($style)";
        style = "bg:black fg:cyan";
        truncation_length = 5;
        truncation_symbol = "…/";
      };
      git_branch = {
        format = "$branch";
        symbol = ""; # Removes the default  icon to match your original prompt
      };
      git_status = {
        format = "$all_status";
        modified = "*";
        staged = "+";
        untracked = ""; # Hides untracked files to keep it strictly to * and +
      };
      character = {
        format = " $symbol ";
        success_symbol = "[❱](white)";
        error_symbol = "[❱](red)";
        vicmd_symbol = "[❱](white)"; # Keeps the chevron white when you switch to normal mode
      };
    };
  };

  programs.zsh = {
    enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      share = true;
    };

    shellAliases = {
      cl = "clear";
      ga = "git add";
      gcm = "git commit -m";
      gss = "git status";
      histgrep = "echo '[Tip] Use !number to execute the command' && history -i | grep";
      l = "ls -A -l -h --color=auto";
      nv = "neovide --fork";
      v = "nvim";
      manf = "compgen -c | fzf | xargs man";
      cdf_edit = "$EDITOR $THEOSHELL_CDF_DIR";
    };

    initContent = ''
      # Vim mode
      bindkey -v
      KEYTIMEOUT=1
      bindkey '^R' history-incremental-search-backward
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line

      mkcd() { mkdir -p $1; cd $1 }
      numfiles() {
        num=$(ls -A $1 | wc -l)
          echo "$num files in $1"
      }
      tarmake() { tar -czvf ''${1}.tar.gz $1 }
      tarunmake() { tar -zxvf $1 }

      function zsh_greeting() {
        # Colors
        normal='\033[0m'

        red='\033[0;31m'
        brred='\033[1;31m'
        green='\033[0;32m'
        brgreen='\033[1;32m'
        yellow='\033[0;33m'
        bryellow='\033[1;33m'
        blue='\033[0;34m'
        brblue='\033[1;34m'
        magenta='\033[0;35m'
        brmagenta='\033[1;35m'
        cyan='\033[0;36m'
        brcyan='\033[1;36m'

        # Collection of Oliver ASCII arts
        olivers=(
          '
             \/   \/
             |\__/,|     _
           _.|o o  |_   ) )
          -(((---(((--------
          ' \
          '
                                     _
             |\      _-``---,) )
       ZZZzz /,`.-```    -.   /
             |,4-  ) )-,_. ,\ (
            `---``(_/--`  `-`\_)
          ' \
          '
             \/   \/
             |\__/,|        _
             |_ _  |.-----.) )
             ( T   ))         )
            (((^_(((/___(((_/
          '
        )

        # ESCAPED FOR NIX:
        # 1. RANDOM is biased toward the lower index
        # 2. Array index in ZSH starts at 1
        oliver=''${olivers[ $(( RANDOM % ''${#olivers[@]} + 1 )) ]}

        # Other information
        zsh_ver="$(zsh --version)"
        uptime=$(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 " " }')

        # Greeting msg
        echo
        echo -e "  " "$brgreen" "Meow"                              "$normal"
        echo -e "  " "$brred"   "$oliver"                           "$normal"
        echo -e "  " "$cyan"    "  Shell:\t"   "$brcyan$zsh_ver"  "$normal"
        echo -e "  " "$blue"    "  Uptime:\t"  "$brblue$uptime"   "$normal"
        echo
      }

      zsh_greeting
    '';
  };

  programs.fish = {
    enable = true;
  };

  # home.file.".config/fish" = {
  #   source = ../../fish;
  #   recursive = true;
  # };
}
