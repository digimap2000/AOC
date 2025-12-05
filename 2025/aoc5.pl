my @fresh;
my ($p1,$p2) = (0,0);

sub uniquify {
    foreach my $i (0..scalar(@fresh)-1) {
        my ($a,$b) = ($fresh[$i]->[0],$fresh[$i]->[1]);
        foreach my $j (0..scalar(@fresh)-1) {
            next if $i eq $j;
            my ($min,$max) = ($fresh[$j]->[0],$fresh[$j]->[1]);
            my $ain = (($a >= $min) && ($a <= $max));
            my $bin = (($b >= $min) && ($b <= $max));
            next unless $ain || $bin;

            $fresh[$j]->[1] = $b if $ain && !$bin;
            $fresh[$j]->[0] = $a if $bin && !$ain;
            splice(@fresh,$i,1);
            return 1;
        }
    }
    return 0;
}

sub find {
    my ($a) = @_;
    foreach (@fresh) {
        return 1 if ($a >= $_->[0]) && ($a <= $_->[1]);
    }
    return 0;
}

while (<>) {
    last unless chomp($_) && $_;
    push(@fresh,[split('-',$_)]);
}

while (uniquify()) {}

while (<>) {
    $p1++ if chomp($_) && $_ && find($_);
}

foreach (@fresh) { 
    $p2 += @{$_}[1] - @{$_}[0] + 1;
}

print "Part One: " . $p1 . "\n";   # 563
print "Part Two: " . $p2 . "\n";   # 338693411431456