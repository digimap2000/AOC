#
# The trick here is recognising that 
# (a) Stones do not depend on other stones
# (b) We don't care about the order of the stones
# (c) Stone numbers never get above about 8 digits
#
# So using this the key is to understand that whilst the population
# will grow into the trillions there will only ever be a much smaller
# finite set of stone numbers. If we track how many of each stone number
# we have in each generation we only have to evolve each unique stone
# once and multiply up the results by the current population of that
# specific numbered stone. Dump the population at the end and you'll
# there are only 3792 unique stones but trillions of some.
#
use Data::Dumper;

while (<>) {
    chomp();
    foreach (split(/\W+/,$_)) {
        $pop->{$_} = 1;
    }
};

sub evolve {
    my ($pop) = @_;
    $new = {};    
    foreach (keys %$pop)
    {
        $new->{1} += $pop->{$_}, next if $_ eq 0; 
        if (((length $_) % 2) eq 0)
        {
            $h = (length $_) / 2;
            $new->{int(substr($_, 0, $h))} += $pop->{$_};
            $new->{int(substr($_, $h, $h))} += $pop->{$_};
            next;
        }
        $new->{$_ * 2024} += $pop->{$_}; 
    }
    return $new;
}

sub headcount {
    my $total = 0;
    foreach (keys %$pop) {
        $total += $pop->{$_};
    }
    return $total;
}

foreach (1..75)
{
    $pop = evolve($pop);
    $p1 = headcount() if $_ eq 25;
    $p2 = headcount() if $_ eq 75;
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
