use strict;
use Data::Dumper;

my ($p1,$p2) = (0,0);
my $map = {};

sub neighbours {
    my ($row,$col) = @_;
    my $count = 0;
    foreach my $x (-1,0,1) {
        foreach my $y (-1,0,1) {
            next unless $x || $y;
            $count++ if $map->{$row+$y}->{$col+$x} eq '@';
        }
    }
    return $count;
}

sub remove {
    my @candidates;
    foreach my $y (sort {$a <=> $b} keys %$map) {
        foreach my $x (sort {$a <=> $b} keys %{$map->{$y}}) {
            next unless $map->{$y}->{$x} eq '@';
            push(@candidates, $y . '_' . $x) if neighbours($y,$x) < 4;
        }
    }
    foreach (@candidates) {
        my ($y,$x) = split('_',$_);
        $map->{$y}->{$x} = '.';
    }
    return scalar(@candidates);
}

my $row = 1;
while (<>) {
    chomp($_);

    my $col = 1;
    my @a = split('',$_);
    foreach (@a) {
        $map->{$row}->{$col++} = $_;
    }
    $row++;
}

while (my $rolls = remove()) {
    $p1 += $rolls unless $p1;
    $p2 += $rolls;
}

print "Part One: " . $p1 . "\n";   # 1424
print "Part Two: " . $p2 . "\n";   # 8727