my $seen = {};
my @towels;

sub try {
    my ($p,$from) = @_;
    my $len = length($p);
    $seen->{$len} .= ("_" . $from), return if defined $seen->{$len};
    $seen->{$len} = $from;
    foreach (@towels) {
        next unless (length($_) <= $len) && ($p =~ /^$_(.*)$/);
        try($1,$len);
    }
}

while (<>) {
    chomp();
    next unless $_;
    @towels = split(/\s*,\s*/,$_), next if ($_ =~ /,/);
    
    $seen = {};
    try($_,"X");

    my $totals = {};
    for my $key (reverse sort {$a <=> $b} keys %$seen) {
        foreach (split(/_/,$seen->{$key})) {
            $totals->{$key} += (($_ eq 'X') ? 1 : $totals->{$_});
        }
    }    
    $p1++ if defined $totals->{0};
    $p2 += $totals->{0};
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
