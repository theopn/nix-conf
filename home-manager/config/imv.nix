{ ... }:

{
  programs.imv = {
    enable = true;
    settings = {
      options = {
        background = "#000000";
        loop_input = true;
        overlay = true;   # d to toggle
        recursively = true;  # use :open -r .
        scaling_mode = "shrink";
      };
      binds = {
        n = "next 1";
        p = "prev 1";
      };
    };
  };
}
