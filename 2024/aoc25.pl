
use Data::Dumper;
my $ip;
my $count;
my $locks;
my $keys;

sub analyse {
    my @pins;
    my $locknotkey = ($ip->{0} eq '#####') ? 1 : 0;
    foreach my $i (0..4) {
        my $height = 0;
        foreach($locknotkey ? (sort keys %$ip) : (reverse sort keys %$ip)) {
            last unless substr($ip->{$_},$i,1) eq '#';
            $height++;
        }
        push(@pins,$height-1);
    }
    $locks->{scalar keys %$locks} = join(',',@pins) if $locknotkey;
    $keys->{scalar keys %$keys} = join(',',@pins) unless $locknotkey;
    $count = 0;
    $ip = {};
}

while (<>) {
    chomp();
    analyse(), next unless $_;
    $ip->{$count++} = $_;
}

foreach my $l (sort keys %$locks) {
    my @l = split(',',$locks->{$l});
    foreach my $k (sort keys %$keys) {
#        print $locks->{$l} . " " . $keys->{$k} . "\n";
        my @k = split(',',$keys->{$k});
        my $m = 1;
        foreach (0..4) {
            $m=0, last unless (@l[$_] + @k[$_] <= 5);
        }
        $p1++ if $m;
    }
}

#print Dumper $locks;
#print Dumper $keys;

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
