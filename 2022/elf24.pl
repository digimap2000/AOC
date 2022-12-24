#!/usr/bin/perl
use Data::Dumper;

$|=1;

sub blizzard {
    my ($time, $x, $y) = @_;

        return 0;

}



$maxx = 7;
$maxy = 7;

$targetx = $maxx-1;
$targety = $maxy;

$row = 0;
open(FH, '<', 'aoc24.txt');
while (<FH>)
{
    chomp;
    $col = 0;
    for $coord (split //, $_)
    {        
        $col++;
        push(@{$bliz->{'NS'}}, join('_',$row,-1)) if $coord eq '^';
        push(@{$bliz->{'NS'}}, join('_',$row,+1)) if $coord eq 'v';
        push(@{$bliz->{'EW'}}, join('_',$col,-1)) if $coord eq '<';
        push(@{$bliz->{'EW'}}, join('_',$col,+1)) if $coord eq '>';
    }
    $row++;
}

print Dumper $bliz;

my @it = ('0_1_0');
my $best = 30;

while (@it)
{
    my ($time,$x,$y) = split /_/, shift(@it);

    if ($time < $best)
    {
        for ([-1,0],[+1,0],[0,-1],[0,+1],[0,0])
        {
            my $canx = $x + @{$_}[0];
            my $cany = $y + @{$_}[1];

            if (($canx == $targetx) && ($cany == $targety))
            {
                if ($time < $best) {
                    $best = $time;
                }
                print "finished in" . $time . "\n";
            }
            elsif (($canx > 0) && ($canx < $maxx) && ($cany > 0) && ($cany < $targety))
            {
                printf("Iterations: %d %d %d\n", $time+1, $canx, $cany) if ($perm++ % 100000) eq 0;

                if (not blizzard($time+1,$canx,$cany))
                {
                        push(@it, join('_',$time+1,$canx,$cany));
                }
            }
        }  
    }     
}

