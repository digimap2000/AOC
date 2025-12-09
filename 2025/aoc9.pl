
use Math::Geometry::Planar;

my @red;

sub distance {
    my ($a,$b) = @_;
    my $dx = abs($a->[0] - $b->[0]) + 1;
    my $dy = abs($a->[1] - $b->[1]) + 1;
    return $dx * $dy;
}

sub biggest {
    my $max = 0;
    foreach my $x (0..scalar(@red)-1)
    {
        foreach my $y ($x+1..scalar(@red)-1)
        {
            my $d = distance(@red[$x],@red[$y]);
            $max = $d if $d > $max;
        }
    }
    return $max;
}

while (<>) {
    chomp($_);
    push(@red, [split(',',$_)]);
}

print biggest() . "\n";
