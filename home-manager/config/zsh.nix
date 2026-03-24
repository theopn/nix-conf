{ ... }:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
    };

    shellAliases = {
      cl = "clear";

      ga = "git add";
      gcm = "git commit -m";
      gss = "git status";

      l = "eza -a -l --header --git --total-size --time-style iso --icons auto --color auto";
      nv = "neovide --fork";
      v = "nvim";

      keychain_load = "eval $(keychain --eval id_ed25519 id_rsa)";
    };

    initContent = ''
      # Vim mode
      bindkey -v
      KEYTIMEOUT=1
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
    '';
  };
}
