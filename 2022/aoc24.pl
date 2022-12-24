#!/usr/bin/perl
use List::MoreUtils qw(uniq);

sub blizzard {
    my ($time, $x, $y) = @_;
    foreach (@{$bliz->{'NS'}->{$x}},@{$bliz->{'EW'}->{$y}})
    {
        my ($offset,$velocity,$orient) = split /_/, $_;
        $position = ($offset + ($time * $velocity)) % (($orient eq 'V') ? $maxy : $maxx);
        return 1 if $position == (($orient eq 'V') ? $y : $x);
    }
}

sub minute {
    my $count = scalar(@it);
    while ($count--)
    {
        my ($time,$x,$y) = split /_/, shift(@it);

        for ([-1,0],[+1,0],[0,-1],[0,+1],[0,0])
        {
            ($canx, $cany) = ($x + @{$_}[0], $y + @{$_}[1]);
            return 1 if ($canx == $targetx) && ($cany == $targety);
            if ((($canx == $x) && ($cany == $y)) || (($canx > $minx) && ($canx < $maxx) && ($cany > $miny) && ($cany < $maxy)))
            {
                push(@it, join('_',$time+1,$canx,$cany)) unless blizzard($time+1,$canx,$cany);
            }
        }     
    }
}

$row = -1;
while (<>)
{
    chomp;
    $maxx = length($_) -2;
    $col = -1;
    for $coord (split //, $_)
    {        
        push(@{$bliz->{'NS'}->{$col}}, join('_',$row,-1,'V')) if $coord eq '^';
        push(@{$bliz->{'NS'}->{$col}}, join('_',$row,+1,'V')) if $coord eq 'v';
        push(@{$bliz->{'EW'}->{$row}}, join('_',$col,-1,'H')) if $coord eq '<';
        push(@{$bliz->{'EW'}->{$row}}, join('_',$col,+1,'H')) if $coord eq '>';
        $col++;
    }
    $row++;
}
$minx = -1;
$miny = -1;
$maxy = $row - 1;

$utc = 0;
($originx,$originy) = ($minx+1, $miny);
($targetx,$targety) = ($maxx-1, $maxy);

for $trip (1..3)
{
    @it = (join('_',$utc,$originx,$originy));
    do {
        $utc++;
        @it = uniq(@it);
    } while (not minute());

    printf("Time after loop %d: %d\n", $trip, $utc);

    ($targetx,$targety,$originx,$originy) = ($originx,$originy,$targetx,$targety);
}
