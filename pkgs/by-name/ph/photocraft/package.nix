{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  stdenv,
}:

let
  pname = "photocraft";
  version = "0.6.0";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-x86_64.AppImage";
        hash = "sha256-Y1+TiT+Unb8Xorwg4cKFqO/byIWchErS+6ro5wCfZ9Y=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-aarch64.AppImage";
        hash = "sha256-1YgB51b+jjsWWWgA1t5J6Hb35lP45obEyUiD4mCDAVQ=";
      };
    }
    .${stdenv.hostPlatform.system};

  contents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    cp -r ${contents}/usr/share $out/

    wrapProgram $out/bin/photocraft \
      --set PHOTOCRAFT_NO_DESKTOP_INTEGRATION 1
  '';

  meta = {
    description = "Open-source native image editor";
    homepage = "https://github.com/storytold/photocraft";
    changelog = "https://github.com/storytold/photocraft/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "photocraft";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
