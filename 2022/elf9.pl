#!/usr/bin/perl
$ropelen = 9;
while (<>) {
    $_ =~ /^([UDLR]) ([\d]*)/;
    for (1..$2) {
        ($1 eq 'U') && @hy[0]--;
        ($1 eq 'D') && @hy[0]++;
        ($1 eq 'L') && @hx[0]--;
        ($1 eq 'R') && @hx[0]++;
        for ($a=0; $a<$ropelen; ++$a)
        {
            $lr = abs(@hx[$a]-@hx[$a+1]) > 1;
            $ud = abs(@hy[$a]-@hy[$a+1]) > 1;

            $ud && (@hy[$a+1] = @hy[$a+1] + ((@hy[$a] > @hy[$a+1]) ? 1 : -1));
            $ud && (@hx[$a+1] = @hx[$a]) unless $lr;

            $lr && (@hx[$a+1] = @hx[$a+1] + ((@hx[$a] > @hx[$a+1]) ? 1 : -1));
            $lr && (@hy[$a+1] = @hy[$a]) unless $ud;
        }
        $v->{@hx[$ropelen]."_".@hy[$ropelen]}++;
    }
}
print "Tail visitations = " . scalar(keys $v) . "\n";
