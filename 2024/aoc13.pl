use POSIX;

sub analyse {
    my ($but, $ca, $cb, $px, $py) = @_;

    if (($but->{'Ax'} / $but->{'Ay'}) > ($but->{'Bx'} / $but->{'By'})) {
        ($ax,$ay) = ($but->{'Ax'},$but->{'Ay'});
        ($bx,$by) = ($but->{'Bx'},$but->{'By'});
        ($costa,$costb) = ($ca,$cb);
    } else {
        ($ax,$ay) = ($but->{'Bx'},$but->{'By'});
        ($bx,$by) = ($but->{'Ax'},$but->{'Ay'});
        ($costa,$costb) = ($cb,$ca);
    }

    my ($min,$max) = (0,ceil($px / $ax));
    while (($max - $min) > 1) {
        my $guess = ceil(($max + $min) / 2);
        my $steps = ($px - ($guess * $ax)) / $bx;
        my $yproj = ($guess * $ay) + ($steps * $by);

        return (($guess * $costa) + ($steps * $costb))
            if (($steps =~ /^\d+$/) && ($yproj eq $py));

        $max = $guess if ($yproj < $py);
        $min = $guess unless ($yproj < $py);
    }
    return 0;
}

my $button = {};
while (<>) {
    if ($_ =~ /^Button (\w): X\+(\d+), Y\+(\d+)/) {
        $button->{$1.'x'} = $2;
        $button->{$1.'y'} = $3;
        next;
    }
    if ($_ =~ /^Prize: X=(\d+), Y=(\d+)/) {
        $p1 += analyse($button, 3, 1, $1, $2);
        $p2 += analyse($button, 3, 1, $1 + 10000000000000, $2 + 10000000000000);
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
