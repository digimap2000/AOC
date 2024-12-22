use List::Util qw(max);

sub evolve {
    my ($s) = @_;
    $s = ($s ^ $s*64) % 16777216;
    $s = ($s ^ $s/32) % 16777216;
    $s = ($s ^$s*2048) % 16777216;
    return $s;
}

while (<>) {
    chomp();
    my ($s,$pp) = ($_,0);
    my (@ps,$seen) = ((),{});
    foreach (1..2000) {
        my $p = $s%10;
        push(@ps,$p-$pp);
        $s = evolve($s);
        $pp = $p;
        next unless scalar(@ps) >= 4;
        ($score->{join(',',@ps)} += $p) unless $seen->{join(',',@ps)};
        $seen->{join(',',@ps)}++;
        shift(@ps);
    }
    $p1 += $s;
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . (max values %$score) . "\n";
