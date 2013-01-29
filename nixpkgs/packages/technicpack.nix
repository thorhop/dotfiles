{stdenv, fetchurl, jre, libX11, libXext, libXcursor, libXrandr, libXxf86vm
, mesa, openal, alsaOss }:

stdenv.mkDerivation {
  name = "technicpack-0.1";

  src = fetchurl {
    url = "http://mirror.technicpack.net/Technic/technic-launcher.jar";
    sha256 = "79bf1f8d86f1975b1aded487a9f5a93dee96599ca375218791070a151d5c2d4e";
  };

  phases = "installPhase";

  installPhase = ''
    set -x
    mkdir -pv $out/bin
    cp -v "$src" $out/technic-launcher.jar

    cat > $out/bin/technicpack << EOF
    #!${stdenv.shell}

    # wrapper for FTB
    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${jre}/lib/${jre.architecture}/:${libX11}/lib/:${libXext}/lib/:${libXcursor}/lib/:${libXrandr}/lib/:${libXxf86vm}/lib/:${mesa}/lib/:${openal}/lib/
    ${alsaOss}/bin/aoss ${jre}/bin/java -jar $out/technic-launcher.jar
    EOF

    chmod +x $out/bin/technicpack
  '';

  meta = {
      description = "Technic Pack: Launcher and mod selection for Minecraft";
      homepage = http://www.technicpack.net/;
      maintainers = [ ];
      license = "unfree-redistributable";
  };
}
