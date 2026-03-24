{ ... }:

{
  programs.eza = {
    enable = true;

    # integration replaces `ls`, I just liek making an alias
    enableZshIntegration = false;
    enableFishIntegration = false;

    colors = "auto";
    icons = "auto";  # only output if stdout = terminal
  };
}
