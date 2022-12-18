#!/usr/bin/perl
#
# When playing arg(0) against arg(1) obviously equality is
# a draw but the trick is to recognise winners lead losers
# and losers lead winners when played numerically on a 
# wrapped mod3 number line. Think about it.
#
# This is precisely why we choose 0,1,2 over 1,2,3 so the mod3
# plays nice but dont forget to add 1 to get the play score.
#
sub play {
    return @_[1] + 1 + 3 if @_[1] == @_[0];
    return @_[1] + 1 + 6 if (((@_[0] - @_[1]) % 3) == 2);
    return @_[1] + 1;
}

#
# With the play and score algorithm abstracted out all that is left
# is to iterate through the rounds tallying up the scores. For part
# one we are given the input to play, for part 2 we have to mangle
# our input to force a win, lose or draw. Again we deploy the mod3
# trick to compute how to do that relative to what they picked.
#
sub part {
    my ($part,$result,$tally) = @_;
    for (@rounds)
    {
        ($a, $b) = split / /, $_;
        ($part == 1) && ($tally += play($a,$b));  
        ($part == 2) && ($tally += play($a,(($a+$b+2)%3)));  
    }
    printf("Part %d: %d vs %d ... %s\n", $part, $tally, $result,
        $tally == $result ? "PASS" : "FAIL");
}

#
# To make life easier later on we slurp the input into 
# rounds of the game using 0,1,2 to represent rock
# paper, scissors no matter who plays them. 
#
while (<>) {
    $_ =~ s/[AX]/0/g;
    $_ =~ s/[BY]/1/g;
    $_ =~ s/[CZ]/2/g;
    push (@rounds, $_);
}

part(1,10994);
part(2,12526);

