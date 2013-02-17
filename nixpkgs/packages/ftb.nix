{stdenv, fetchurl, jre, libX11, libXext, libXcursor, libXrandr, libXxf86vm
, mesa, openal, alsaOss }:

# consider making a proper package, using this:
# https://github.com/Slowpoke101/FTBLaunch

stdenv.mkDerivation {
  name = "ftb-1.2.2";

  src = ./FTB_Launcher.jar;

  phases = "installPhase";

  installPhase = ''
    set -x
    mkdir -pv $out/bin
    cp -v "$src" $out/FTB_Launcher.jar

    cat > $out/bin/ftb << EOF
    #!${stdenv.shell}

    # wrapper for FTB
    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${jre}/lib/${jre.architecture}/:${libX11}/lib/:${libXext}/lib/:${libXcursor}/lib/:${libXrandr}/lib/:${libXxf86vm}/lib/:${mesa}/lib/:${openal}/lib/
    ${alsaOss}/bin/aoss ${jre}/bin/java -jar $out/FTB_Launcher.jar
    EOF

    chmod +x $out/bin/ftb
  '';

  meta = {
      description = "Feed The Beast: Launcher and mod selection for Minecraft";
      homepage = http://feed-the-beast.com/;
      maintainers = [ ];
      license = "unfree-redistributable";
  };
}
