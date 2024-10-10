# random-gif-module.nix
{ lib, pkgs, config, ... }:

with lib;

{
  options.services.gifWallpaper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the random GIF-to-PNG conversion service.";
    };

    dir = mkOption {
      type = types.path;
      default = null;
      description = "The path to the directory containing GIF files to convert.";
    };

    png = mkOption {
      type = types.path;
      description = "The output path of the converted PNG file.";
    };

    gif = mkOption {
      type = types.path;
      description = "The output path of the randomly chosen gif.";
    };

    random = mkOption {
      type = types.string;
      description = "Random string to force package rebuild";
    };
  };

  config = let 
    outputDerivation = pkgs.callPackage ./gif-to-wallpaper.nix {
      inherit (config.services.gifWallpaper) dir random;
    };
  in
  {
    services.gifWallpaper = {
      png = outputDerivation + "/output.png";
      gif = outputDerivation + "/random.gif";
    };


    # Set environment variable for the gif path
    environment.variables.GIF_PATH = "${outputDerivation}/random.gif";
  };
}
