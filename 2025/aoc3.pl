use strict;
my ($p1,$p2) = (0,0);

sub search {
    foreach my $d (9,8,7,6,5,4,3,2,1,0) {
        my $pos = index(@_[0],$d);
        return ($d,$pos) if $pos >= 0;
    }
}

sub joltage {
    my ($a,$length) = @_;
    my $j = '';
    while (length($j) < $length) {
        my ($digit,$pos) = search(substr($a,0,length($a)-($length - 1 - length($j))));
        $a = substr($a,$pos+1);
        $j .= $digit;
    }
    return $j;
}

while (<>) {
    /^(\w)(\d+)/;
    chomp($_);
    $p1 += joltage($_, 2);
    $p2 += joltage($_, 12);
}
print "Part One: " . $p1 . "\n";   # 17330
print "Part Two: " . $p2 . "\n";   # 171518260283767