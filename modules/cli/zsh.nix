{pkgs, lib, ...}: {
  home.packages = with pkgs; [
    zsh-powerlevel10k
    nerd-fonts.roboto-mono
  ];
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    #promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    initContent = lib.mkBefore ''
      # Powerlevel10k Zsh theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      test -f ~/.p10k.zsh && source ~/.p10k.zsh
      eval "$(direnv hook zsh)"
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
      source = ../../config/.p10k.zsh;
      executable = true;
    };
  };
}
