use Data::Dumper;

my @boxes;
my $circuits = {};
my $circuitnum = 1;
my $threshold = 0;

sub distance {
    my ($a,$b) = @_;
    my $dx = $a->[0] - $b->[0];
    my $dy = $a->[1] - $b->[1];
    my $dz = $a->[2] - $b->[2];
    return $dx*$dx + $dy*$dy + $dz*$dz;
}

sub closest {
    my @pair;
    my $min = 9999999999;

    foreach my $x (0..scalar(@boxes)-1)
    {
        foreach my $y ($x+1..scalar(@boxes)-1)
        {
            my $d = distance(@boxes[$x],@boxes[$y]);
            if (($min > $d) && ($d > $threshold))
            {
                $min = $d;
                @pair = ($x,$y);

#                print "New Closest: $x, $y\n";
 #               print join(':',@{@boxes[$x]});
  #              print join(':',@{@boxes[$y]});
   #             print "\n\n";
            }
        }
    }

    if (defined $circuits->{@pair[0]} && defined $circuits->{@pair[1]})
    {
        if ($circuits->{@pair[0]} != $circuits->{@pair[1]})
        {
            my $merge = $circuits->{@pair[1]};
            foreach (keys %{$circuits})
            {
                next unless $circuits->{$_} eq $merge; 
                $circuits->{$_} = $circuits->{@pair[0]};
            }
        }

    }
    elsif (defined $circuits->{@pair[0]})
    {
        $circuits->{@pair[1]} = $circuits->{@pair[0]};
    }
    elsif (defined $circuits->{@pair[1]})
    {
        $circuits->{@pair[0]} = $circuits->{@pair[1]};
    }
    else
    {
        $circuits->{@pair[0]} = $circuitnum;
        $circuits->{@pair[1]} = $circuitnum;
        $circuitnum++;
    }

    $threshold = $min;

    print join(':',@{@boxes[@pair[0]]});
    print "     ";
    print join(':',@{@boxes[@pair[1]]});

    return @pair;
}

while (<>) {
    last unless chomp($_) && $_;
    push(@boxes, [split(',',$_)]);
}

while (1) {
    my @res = closest();
    print "   " . join(':', @res);

    my $count = 0;
    my $seen = {};
    foreach (keys %{$circuits})
    {
        $seen->{$circuits->{$_}}++
    }
    $count = scalar(keys %{$seen});
    print " ----- " . $count . "   " . scalar(keys %{$circuits}) . "\n";

    if (scalar keys %{$circuits} eq scalar(@boxes))
    {        
        $p2 = @{@boxes[@res[0]]}[0] * @{@boxes[@res[1]]}[0];
        last;
    }

}

my $sorta = {};
foreach (keys %{$circuits})
{
    $sorta->{$circuits->{$_}}++;
}

$p1 = 1;
my $noodle = 3;
foreach (reverse sort {$sorta->{$a} <=> $sorta->{$b}} keys %{$sorta} )
{
    print $sorta->{$_} . " ";
    $p1 = $p1 * $sorta->{$_};
    last unless --$noodle;    
}

#print Dumper $circuits;
#print Dumper $sort;

print "Part One: " . $p1 . "\n";   # 1533
print "Part Two: " . $p2 . "\n";   # 10733529153890

