{pkgs,lib,config,...}:
{
  options = {
    games.df.enable = lib.mkEnableOption "Enable DF";
  };
  config = lib.mkIf config.games.df.enable {
    environment.systemPackages = with pkgs; [
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        enableFPS = true;
      })
    ];
  };
}
