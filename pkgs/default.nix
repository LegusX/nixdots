# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  prismlaunchernew = pkgs.prismlauncher.override {jdks = [pkgs.jdk22];};
}
