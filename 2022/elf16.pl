#!/usr/bin/perl

use Data::Dumper;

#Parsing beacon positions

while (<>)
{
    ($v,$f,$d) = $_ =~ /^Valve ([A-Z]{2}).*\=(\d+);(.*)$/;
    $d =~ s/[^A-Z,]//g;

    $cave->{$v}->{'flow'} = $f;
    $cave->{$v}->{'exit'} = [split ',',$d];
}

#Recursive grid scanning
sub explore {
    my ($pos, $time, $flow, $score, %open) = @_;

    if (($it++ % 1000000) == 0) {
        print $it++ . " " . (keys %open) . " " . $time . " @ " . $score . "\n";
    }

    if ($time >= 30)
    {
        if ($score > $best) {
            print "Hi Score: " . $score . "\n";
            $best = $score;
        }
    }

    else
    {
        if ((keys %open) >= 6)
        {
            $time++;
            $score += $flow;
            explore($pos,$time,$flow,$score,%open);
        }
        else
        {                        
            if ($cave->{$pos}->{'flow'} > 0)
            {
                if (not defined $open{$pos})
                {
                    $score += $flow;
                    $flow+=$cave->{$pos}->{'flow'};
                    $open{$pos} = $time;
                    $time++;
                }
            }

            $time++;
            $score += $flow;
            for (@{$cave->{$pos}->{'exit'}})
            {
                explore($_,$time,$flow,$score,%open);
            }
        }
    }

}


explore('AA', 0, 0, 0, {});

#print Dumper $cave;

