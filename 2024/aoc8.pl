my $map = {};
my $an = {};

my $width = 0;
my $height = 0;
while (<>)
{
    chomp();
    $width = length($_);
    for ($x=0; $x<$width; $x++)
    {
        $c = substr($_,$x,1);
        next if $c eq '.';
        $map->{$c} = [] unless $map->{$c};
        push @{$map->{$c}}, [$x, $height];
    }
    $height++;
}

sub check {
    my ($a, $b, $mx, $my) = @_;
    $dx = @$b[0] - @$a[0];
    $dy = @$b[1] - @$a[1];

    $anx = @$a[0] - $dx;
    $any = @$a[1] - $dy;
    $an->{$anx . "-" . $any}++ unless ($anx<0) || ($anx>=$mx) || ($any<0) || ($any>=$my);

    $anx = @$b[0] + $dx;
    $any = @$b[1] + $dy;
    $an->{$anx . "-" . $any}++ unless ($anx<0) || ($anx>=$mx) || ($any<0) || ($any>=$my);


    return 0 if (abs($dx) % 3) || (abs($dy) % 3);

    return 0;

    $anx = @$a[0] + $dx / 3 * 2;
    $any = @$a[1] + $dy / 3 * 2;
    $an->{$anx . "-" . $any}++ unless ($anx<0) || ($anx>=$mx) || ($any<0) || ($any>=$my);

    $anx = @$a[0] + $dx / 3 * 1;
    $any = @$a[1] + $dy / 3 * 1;
    $an->{$anx . "-" . $any}++ unless ($anx<0) || ($anx>=$mx) || ($any<0) || ($any>=$my);

    return 1;
}

sub check2 {
    my ($a, $b, $mx, $my) = @_;
    $dx = @$b[0] - @$a[0];
    $dy = @$b[1] - @$a[1];

    $anx = @$a[0];
    $any = @$a[1];
    while (($anx>=0) && ($anx<$mx) && ($any>=0) && ($any<$my))
    {
        $an->{$anx . "-" . $any}++ unless ($anx<0) || ($anx>=$mx) || ($any<0) || ($any>=$my);
        $anx -= $dx;
        $any -= $dy;
    }

    $anx = @$a[0];
    $any = @$a[1];
    while (($anx>=0) && ($anx<$mx) && ($any>=0) && ($any<$my))
    {
        $an->{$anx . "-" . $any}++ unless ($anx<0) || ($anx>=$mx) || ($any<0) || ($any>=$my);
        $anx += $dx;
        $any += $dy;
    }

    return 1;
}

foreach $frequency (sort keys %$map)
{
    my $locations = $map->{$frequency};
    for (my $x=0; $x<scalar(@$locations); $x++)
    {
        for (my $y=$x+1; $y<scalar(@$locations); $y++)
        {
            check(@$locations[$x], @$locations[$y], $width, $height);
        }
    }
}

$p1 = scalar keys %$an;

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";