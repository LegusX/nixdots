{ lib
, stdenv
, fetchFromGitHub
, nodePackages
, electron
, libpulse
, pkg-config
, python3
, gcc
, nodejs
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "haven-desktop";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ancsemi";
    repo = "Haven-Desktop";
    rev = "v${version}";
    hash = "sha256-pbuOOMfI03oiVJLNttElKAhEr4zcAc54Cv0Sx+zYtt8="; # TODO: Run nix flake prefetch
  };

  npmDepsHash = "sha256-B6vos0G5Ch2p39J4u4KOb30x6hs29mA2jFP5jKebyGw=";

  nativeBuildInputs = [
    pkg-config
    python3
    gcc
  ];

  buildInputs = [
    libpulse
  ];

  preBuild = ''
    npm run build:native
  '';

  postInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/lib

    # Copy built app to output
    cp -r . $out/lib/haven-desktop

    # Create wrapper script
    cat > $out/bin/haven-desktop <<EOF
    #!${stdenv.shell}
    ${electron}/bin/electron $out/lib/haven-desktop/src/main/main.js "\$@"
    EOF
    chmod +x $out/bin/haven-desktop
  '';

  meta = with lib; {
    description = "Haven Desktop — Private chat, reimagined for your desktop";
    homepage = "https://github.com/ancsemi/Haven-Desktop";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}
