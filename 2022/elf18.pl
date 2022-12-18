#!/usr/bin/perl
while (<>)
{
    chomp;
    /^(\d+),(\d+),(\d+)/;
    $cubes->{$_} = {};
    $world->{$1}->{$2}->{$3} = '#';
}

sub neighbours {
    my ($x,$y,$z,$what)  = @_;
    my $n = 0;
    $n++ if $world->{$x+1}->{$y}->{$z} eq $what;
    $n++ if $world->{$x-1}->{$y}->{$z} eq $what;
    $n++ if $world->{$x}->{$y+1}->{$z} eq $what;
    $n++ if $world->{$x}->{$y-1}->{$z} eq $what;
    $n++ if $world->{$x}->{$y}->{$z+1} eq $what;
    $n++ if $world->{$x}->{$y}->{$z-1} eq $what;
    return $n;
}

sub part1 {
    my $n = 0;
    for (keys $cubes) {
        $n += neighbours((split /,/, $_),'#');
    }
    print "Faces=" . ((scalar(keys $cubes) * 6) - $n) . "\n";
}

sub part2 {
    my $n = 0;
    my $min = 0 - 1;
    my $max = 19 + 1;
    $world->{$min}->{$min}->{$min} = 'a';
    do {
        $mods = 0;
        for $z ($min..$max) {
            for $y ($min..$max) {
                for $x ($min..$max) {
                    next if defined $world->{$x}->{$y}->{$z};
                    neighbours($x,$y,$z,'a') && ($world->{$x}->{$y}->{$z} = 'a');
                    $mods++ unless not defined $world->{$x}->{$y}->{$z};
                }
            }
        }
    } while ($mods);

    for (keys $cubes) {
        $n += neighbours((split /,/, $_),'a');
    }
    print "Faces=" . $n . "\n";

}

part1();
part2();
