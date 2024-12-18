my $map = {};
my $cost = {};

sub explore {
    my ($x,$y,$m,$c,$t) = @_;
    return if ($x < 0) || ($y < 0) || ($x >= $m) || ($y >= $m);
    return if defined $map->{$x}->{$y} && $map->{$x}->{$y} < $t;
    return if defined $cost->{$x}->{$y} && ($cost->{$x}->{$y} <= $c);
    $cost->{$x}->{$y} = $c;
    return if (($x eq $m) && ($y eq $m));
    explore($x+@$_[0],$y+@$_[1],$m,$c+1,$t) foreach ([1,0],[-1,0],[0,1],[0,-1]);
}

sub verify {
    my ($time,$m) = @_;
    $cost = {};
    explore(0,0,$m,0,$time);
    return (defined $cost->{$m-1}->{$m-1}) ? $cost->{$m-1}->{$m-1} : 0;
}

my $count = 0;
my $lut = {};
while (<>) {
    chomp();
    my ($x,$y) = split(/,/,$_);
    $lut->{$count} = $_;
    $map->{$x}->{$y} = $count++;
}

my ($p1,$max) = (1024,71);
$p1 = verify($p1,$max);
while ($count--) {
    last if verify($count,$max);
    $p2 = $lut->{$count-1};   
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
