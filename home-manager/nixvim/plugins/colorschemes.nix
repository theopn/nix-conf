{ ... }:

{
  programs.nixvim = {
    colorscheme = "nord";

    colorschemes = {
      nightfox = {
        enable = true;
      };

      tokyonight = {
        enable = true;
        settings.style = "night";
      };

      nord.enable = true;
      kanagawa.enable = true;
      onedark.enable = true;
    };
  };
}
