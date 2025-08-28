# This file defines overlays
{inputs, ...}: {
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # freerdp = let
    #   libavif-new = inputs.libavif.legacyPackages."${prev.system}".libavif;

    #   freerdp-new = inputs.freerdp.legacyPackages."${prev.system}".freerdp;
    # in
    #   freerdp-new.overrideAttrs (old: {
    #     buildInputs =
    #       (builtins.filter (pkg: pkg != prev.libavif) old.buildInputs)
    #       ++ [ libavif-new ];
    #   });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
      config.permittedInsecurePackages = [
        "aspnetcore-runtime-6.0.36"
        "aspnetcore-runtime-wrapped-6.0.36"
        "dotnet-sdk-6.0.428"
        "dotnet-sdk-wrapped-6.0.428"
      ];
    };
  };
}
