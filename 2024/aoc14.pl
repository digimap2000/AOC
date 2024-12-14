my ($robots,$w,$h) = ([],101,103);
while (<>) {
    push(@$robots,[$1,$2,$3,$4]) if /^p=([\d]+),([\d]+) v=(-{0,1}[\d]+),(-{0,1}[\d]+)$/;     
};

sub move {
    foreach my $r (@$robots) {
        $r->[0] = ($r->[0] + $r->[2]) % $w;
        $r->[1] = ($r->[1] + $r->[3]) % $h;
    }
}

sub count {
    my ($x,$y) = (($w-1)/2,($h-1)/2);
    my $count = {};
    foreach my $r (@$robots) {
        next if ($r->[0] eq $x) || ($r->[1] eq $y);
        $e = ($r->[0] < $x) ? '0' : '1';
        $n = ($r->[1] < $y) ? '0' : '1';
        $count->{$e . $n}++;
    }
    return $count->{'00'} * $count->{'01'} * $count->{'10'} * $count->{'11'};
}

sub unique {
    my $map = {};
    foreach my $r (@$robots) {
        return 0 if defined $map->{$r->[0]}->{$r->[1]};
        $map->{$r->[0]}->{$r->[1]}++;
    }
    return 1;
}

$p2 = 0;
while (!unique()) {
    move();
    $p1 = count() if ++$p2 eq 100;
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
