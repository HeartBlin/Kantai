{ fetchzip, lib, stdenvNoCC, ... }:

# Basically just the 'proton-ge-bin' package upstream, but its 'dwproton' instead
stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "dwproton-bin";
    version = "dwproton-11.0-1";

    src = fetchzip {
      url = "https://dawn.wine/dawn-winery/dwproton/releases/download/${finalAttrs.version}/${finalAttrs.version}-x86_64.tar.xz";
      hash = "sha256-G8VeHp0POZBHfxN78PCwwm6z7zVNMveAdwf/IMJQ/9Q=";
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    outputs = [ "out" "steamcompattool" ];

    installPhase = ''
      runHook preInstall

      # Maintain the warning from proton-ge-bin package upsteam
      # Also is a plain file
      echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

      mkdir -p $steamcompattool
      ln -s $src/* $steamcompattool
      rm $steamcompattool/compatibilitytool.vdf
      cp $src/compatibilitytool.vdf $steamcompattool

      runHook postInstall
    '';

    preFixup = ''
      substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
        --replace-fail "${finalAttrs.version}" "DW-Proton"
    '';

    meta = {
      description = ''
        Proton builds with the latest Dawn Winery fixes :xdd:

        (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
      '';
      homepage = "https://dawn.wine/dawn-winery/dwproton";
      license = with lib.licenses; [
        bsd3
        mpl20
        lgpl21Plus
        mit
        zlib
        unfreeRedistributable # Valve Proton I think is this?
      ];

      platforms = [ "x86_64-linux" ];
      maintainers = [ ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  })
