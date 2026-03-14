{ ... }:
{
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
        "node_modules/"
    ];
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--hidden"
        "--glob=!.git/"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude '.git'";
    defaultOptions = [
      "--layout=reverse"
        "--cycle"
        "--height=50%"
        "--margin=5%"
        "--border=double"
    ];
  };
}

