while (<>) {
    chomp();
    push(@map,[split(//,$_)])
};

sub explore {
    my ($x,$y,$max,$summit,$seen) = @_;
    $seen->{$x . '-' . $y}++ if $map[$x][$y] eq $summit;
    explore($x+1,$y,$max,$summit,$seen) if ($x<$max) && ($map[$x+1][$y] eq ($map[$x][$y] + 1)); 
    explore($x,$y+1,$max,$summit,$seen) if ($y<$max) && ($map[$x][$y+1] eq ($map[$x][$y] + 1)); 
    explore($x-1,$y,$max,$summit,$seen) if ($x>0) && ($map[$x-1][$y] eq ($map[$x][$y] + 1)); 
    explore($x,$y-1,$max,$summit,$seen) if ($y>0) && ($map[$x][$y-1] eq ($map[$x][$y] + 1)); 
    return $seen;
}

foreach my $x (0..@map-1) {
    foreach my $y (0..@map-1) {
        next unless $map[$x][$y] eq 0;
        my $res = explore($x,$y,@map-1,9,{});
        foreach (keys %{$res}) {
            $p1++;
            $p2+=$res->{$_};
        }
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
