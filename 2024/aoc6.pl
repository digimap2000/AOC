my $map = {};

sub at {
    my ($x,$y) = @_;
    return substr($map->{$y},$x-1,1);
}

sub run {
    my ($x,$y,$ox,$oy,$max) = @_;
    my $visited = {};
    my $i = 0;
    my @dir = ([0,-1],[1,0],[0,1],[-1,0]);
    while (($x > 0) && ($y > 0) && ($x <= $max) && ($y <= $max))
    {
        $visited->{$x . "-" . $y}++;
        return 0 if $visited->{$x . "-" . $y} > 4;

        $x2 = $x+@dir[$i]->[0];
        $y2 = $y+@dir[$i]->[1];

        if ((at($x2,$y2) eq '#') || (($x2 eq $ox) && ($y2 eq $oy)))
        {
            $i = ($i + 1) % scalar @dir;
        }
        else
        {
            $x = $x2;
            $y = $y2;
        }
    }
    return scalar keys %$visited;
}

my $row = 0;
my $x = 0;
my $y = 0;
while (<>)
{
    chomp();
    $map->{++$row} = $_;

    if (index($_, '^') >= 0)
    {
        $y = $row;
        $x = index($_, '^') + 1;
    }
}

my $max = scalar keys %$map;
$p1 = run($x,$y,-1,-1,$max);

foreach my $ox (1 .. $max)
{
    print $ox . "\n";
    foreach my $oy (1 .. $max)
    {
        next unless at($ox,$oy) eq '.';
        $p2++ if run($x, $y, $ox, $oy, $max) eq 0;
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";