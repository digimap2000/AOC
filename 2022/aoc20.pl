#!/usr/bin/perl
use List::MoreUtils qw(first_index);

#
# GROVE POSITIONING SYSTEM
#
# An exercise in shuffling numbers around in a list from a set
# of instructions. Got carried away optimising this down until 
# it is barely readable but the essence is there. The key to
# part two is noticing that the instruction list is no longer
# unique so we need a list of unique tokens to shuffle then
# translate back to the instruction list to get the combination.
#
# Slurp the data
my @instructions = split /\n/, do {local $/; <>};

sub part {
    my ($p, $loops, $decrypt, $combination) = @_;

    # Shuffle it about
    my $len = scalar(@instructions);
    my @tokens = (1..$len);
    for (1..$loops) {
        for $i (1..$len) {
            my $loc = first_index { $_ eq $i } @tokens;
            splice(@tokens,$loc,1);
            splice(@tokens,($loc + (@instructions[$i-1] * $decrypt)) % ($len-1),0,$i);
        }
    }

    # Dereference the result tokens to get the combination
    my $origin = first_index { $_ eq ((first_index { $_ eq 0 } @instructions) + 1) } @tokens;
    for (1..3) {
        $combination += ($decrypt * @instructions[ @tokens[($origin+($_*1000)) % $len] - 1 ]);
    }
    printf("Part %d: %d\n", $p, $combination);
}

part(1, 1, 1);
part(2, 10, 811589153);
