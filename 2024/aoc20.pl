my @map;
my @path;
my $score = {};

sub find {
    my ($w) = @_;
    foreach $y (0..scalar(@map)-1) {
        foreach $x (0..scalar(@{$map[$y]})-1) {
            return ($x,$y) if $map[$y][$x] eq $w;
        }
    }
}

sub follow {
    my ($x,$y,$ex,$ey) = @_;
    while (1) {
        push(@path,$x . "-" . $y);
        return if ($x eq $ex) && ($y eq $ey);
        $score->{$x . "-" . $y} = (scalar keys %$score)+1;
        foreach ([1,0],[0,1],[-1,0],[0,-1]) {
            my ($dx,$dy) = ($x+@$_[0], $y+@$_[1]);
            next if $score->{$dx . "-" . $dy} || $map[$dy][$dx] eq '#'; 
            ($x,$y) = ($dx,$dy);
            last;
        }                
    }
}

while (<>) {
    chomp();
    push (@map,[split(//,$_)]);
}

follow(find('S'),find('E'));

foreach my $i (0..scalar(@path)-1) {
    my ($x,$y) = split(/-/,@path[$i]);
    foreach my $j ($i+1..scalar(@path)-1) {
        my ($a,$b) = split(/-/,@path[$j]);
        my $mh = abs($x-$a) + abs($y-$b);
        next if ($mh > 20) || ((($score->{@path[$j]} - $score->{@path[$i]}) - $mh) < 100);
        $p2++;
        $p1++ if $mh eq 2;
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
