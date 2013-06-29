{stdenv, fetchurl, jre, libX11, libXext, libXcursor, libXrandr, libXxf86vm
, mesa, openal, alsaOss }:

stdenv.mkDerivation {
  name = "minecraft-launcher-1.0";

  src = fetchurl {
    url = "https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar";
    sha256 = "1y0df4yrf48ilnbvzx0s0c1shkwf783r1ra5d1yva55v343swdmx";
  };

  phases = "installPhase";

  installPhase = ''
    set -x
    mkdir -pv $out/bin
    cp -v $src $out/minecraft.jar

    cat > $out/bin/minecraft << EOF
    #!${stdenv.shell}

    # wrapper for minecraft
    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${jre}/lib/${jre.architecture}/:${libX11}/lib/:${libXext}/lib/:${libXcursor}/lib/:${libXrandr}/lib/:${libXxf86vm}/lib/:${mesa}/lib/:${openal}/lib/
    ${alsaOss}/bin/aoss ${jre}/bin/java -jar $out/minecraft.jar
    EOF

    chmod +x $out/bin/minecraft
  '';

  meta = {
      description = "A sandbox-building game";
      homepage = http://www.minecraft.net;
      maintainers = [ stdenv.lib.maintainers.page stdenv.lib.maintainers.shlevy ];
      license = "unfree-redistributable";
  };
}
