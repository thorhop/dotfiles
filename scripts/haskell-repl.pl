#!/run/current-system/sw/bin/perl

use Cwd;

my $orig = getcwd();
my $cabalFound = 1;

until (glob('*.cabal')) {
    chdir '..';
    if (getcwd eq '/') {
        $cabalFound = 0;
        chdir $orig;
        last;
    }
}

if ($cabalFound) {
    print STDERR "Using cabal-dev.\n";
    exec("cabal-dev ghci");
} else {
    print STDERR "No .cabal file found. Using ghci.\n";
    exec("ghci");
}
