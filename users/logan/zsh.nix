{pkgs, ...}: {
  home.packages = with pkgs; [
    zsh-powerlevel10k
    (nerdfonts.override {fonts = ["RobotoMono"];})
  ];
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    #promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    initExtraFirst = ''
      # Powerlevel10k Zsh theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      test -f ~/.p10k.zsh && source ~/.p10k.zsh
    '';
    shellAliases = {
      rebuild = "cd ~/.config/nixos-config && git add . && alejandra . && nh os switch . && git commit";
      ls = "exa -hl";
      lsa = "exa -hal";
    };
  };

  # Fonts
  # fonts.fontconfig = {
  # enable = true;
  # defaultFonts = {
  # sansSerif = ["Roboto Mono"];
  # monospace = ["RobotoMono Nerd Font"];
  # };
  # };

  home.file = {
    ".p10k.zsh" = {
      source = ../../src/.p10k.zsh;
      executable = true;
    };
  };
}
