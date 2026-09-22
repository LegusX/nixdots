{ lib, appimageTools, fetchurl }:

let
  pname = "haven-desktop";
  version = "1.2.0"; # replace with actual release

  src = fetchurl {
    url = "https://github.com/ancsemi/Haven-Desktop/releases/download/v${version}/Haven-${version}.AppImage";
    hash = "sha256-7GRsnwtccDOlhSNntzQYRROF38GPVounLDMWV/4IHEY=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    libpulseaudio
    alsa-lib
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    libGL
    gtk3
    nss
    nspr
  ];

  meta = with lib; {
    description = "Haven Desktop client (AppImage)";
    homepage = "https://github.com/ancsemi/Haven-Desktop";
    platforms = platforms.linux;
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/haven-desktop.desktop <<EOF
    [Desktop Entry]
    Name=Haven Desktop
    Exec=${pname}
    Type=Application
    Categories=Network;
    EOF
  '';
}
