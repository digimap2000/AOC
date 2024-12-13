while (<>) {
    chomp();
    push(@map,[split(//,$_)])
};

sub expand {
    my ($region,$x,$y,$v) = @_;
    return 0 if $x<0 || $x>=scalar @map || $y<0 || $y>=scalar @map || $map[$x][$y] ne $v;
    $map[$x][$y] = '.';
    $region->{join('-',($x,$y))}++;
    expand($region,$x+@$_[0],$y+@$_[1],$v) foreach ([1,0],[-1,0],[0,-1],[0,1]);
    return $region;
}

sub perimeter {
    my ($p, $p1, $p2, $reg) = ({}, @_);
    foreach (keys %{$reg}) {
        my ($x,$y) = split('-',$_); 
        foreach (['n',0,1],['s',0,-1],['e',1,0],['w',-1,0]) {
            $p->{join('-',($x,$y,@$_[0]))}++ unless defined $reg->{join('-',($x+@$_[1],$y+@$_[2]))};
        }
    }
    my $discount = 0;
    foreach (keys %{$p}) {
        my ($x,$y,$dir) = split(/-/,$_);
        foreach (['n',1,0],['s',1,0],['e',0,1],['w',0,1]) {
            $discount++ if ($dir eq @$_[0]) && defined $p->{join('-',($x+@$_[1],$y+@$_[2],@$_[0]))};
        }
    }
    my ($area, $panels) = (scalar keys %{$reg}, scalar keys %{$p});
    return ($p1 + ($panels * $area), $p2 + (($panels - $discount) * $area));
}

foreach my $y (0..scalar @map-1) {
    foreach my $x (0..scalar @map-1) {
        next if $map[$x][$y] eq '.';
        ($p1, $p2) = perimeter($p1, $p2, expand({},$x,$y,$map[$x][$y]));
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
