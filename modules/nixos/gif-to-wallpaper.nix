# gif-to-wallpaper.nix
{
  pkgs,
  dir,
  random,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "random-gif-to-wallpaper";

  buildInputs = [pkgs.imagemagick pkgs.coreutils pkgs.bash];

  src = dir;

  # Use the 'dir' variable for the GIF directory
  buildPhase = ''
    echo "Selecting a random ${random} .gif file from the directory: ${dir} idk"
    gifFile=$(find ${dir} -type f -name "*.gif" | shuf -n 1)
    if [ -z "$gifFile" ]; then
      echo "Error: No .gif files found in the specified directory."
      exit 1
    fi
    echo "Selected GIF file: $gifFile"
    gifFile=${dir}/Clouds.gif

    echo "Converting $gifFile to PNG..."
    mkdir -p $out
    convert "$gifFile[0]" "$out/output.png"
    cp $gifFile $out/random.gif
  '';

  installPhase = ''
    echo "Conversion complete. PNG file located at $out/output.png"
  '';
}
