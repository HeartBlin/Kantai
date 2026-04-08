{ pkgs, ... }:

let
  version = "26.0.1";
  src = builtins.fetchurl {
    url = "https://LTspice.analog.com/download/${version}/LTspice64.msi";
    sha256 = "sha256:1080xi3qr059j5j34ribchgn6yw7r2iy6yxiaypd4cpdjxk04dgc";
  };

  launcher = pkgs.writeShellScriptBin "ltspice" ''
    export WINEPREFIX="''${HOME}/.ltspice"
    export WINEARCH="win64"
    export WINEDLLOVERRIDES="winemenubuilder.exe=d;mscoree=d;mshtml=d"

    ltspice_exe="''${WINEPREFIX}/drive_c/Program Files/ADI/LTspice/LTspice.exe"
    wine="${pkgs.wineWow64Packages.stable}/bin/wine"

    if [ ! -f "$ltspice_exe" ]; then
      echo "Not found. Running installer..."
      "$wine" msiexec /i "${src}"
      echo "Installer done. Trying to launch LTspice..."
    fi

    if [ -f "$ltspice_exe" ]; then
      exec "$wine" "$ltspice_exe" "$@"
    else
      echo "Installation failed."
      exit 1
    fi
  '';

  desktopItem = pkgs.makeDesktopItem {
    name = "ltspice";
    desktopName = "LTspice ${version}";
    comment = "SPICE Simulator";
    exec = "ltspice";
    icon = "ltspice";
    categories = [ "Development" "Electronics" ];
    startupWMClass = "ltspice.exe";
  };
in
  pkgs.stdenv.mkDerivation {
    pname = "ltspice";
    inherit version src;

    nativeBuildInputs = [
      pkgs.msitools
      pkgs.icoutils
      pkgs.imagemagick
      pkgs.copyDesktopItems
    ];

    desktopItems = [ desktopItem ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/pixmaps

      mkdir tmp && cd tmp
      msiextract "${src}"
      find . -name "LTspice.exe" -exec wrestool -x -t 14 "{}" \; -quit \
        | magick ico:- -thumbnail 256x256 "$out/share/pixmaps/ltspice.png"
      cd ..

      ln -s ${launcher}/bin/ltspice $out/bin/ltspice

      runHook postInstall
    '';
  }
