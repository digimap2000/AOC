my $comp = {};
my $cluster = {};

sub party {
    my ($m,$club,$count) = @_;
    my @members = split(",",$m);
    foreach $i (0..scalar(@members)-1) {
        my @new;
        foreach $j ($i..scalar(@members)-1) {
            push(@new,@members[$j]) if defined $comp->{@members[$i]}->{@members[$j]};
        }
        party(join(",",@new), $club . "," . $members[$i], $count+1), next if (scalar @new) > 0;
        $cluster->{join(",",sort (split(",",$club), $members[$i]))}++;
    }
}

while (<>) {
    chomp();
    my ($a,$b) = split('-',$_);
    $comp->{$a}->{$b}++;
    $comp->{$b}->{$a}++;
}

#p1
my $groups = {};
foreach (keys %$comp) {
    next unless $_ =~ /^t/;
    foreach $i (keys %{$comp->{$_}}) {
        foreach $j (keys %{$comp->{$_}}) {
            next if $i eq $j;
            next unless $comp->{$i}->{$j};
            my @net = ($_,$i,$j);
            $groups->{join(' ', sort @net)}++;
        }
    }
}
print "Part One: " . (scalar keys %$groups) . "\n";

# p2
foreach (keys %$comp) {
    party(join(",",sort keys %{$comp->{$_}}),$_,0);    
}
print "Part Two: " . (reverse sort {length($a) <=> length($b)} keys %$cluster)[0] . "\n";

