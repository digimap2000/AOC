#!/usr/bin/perl
use List::Util qw/max/;

#
# Not Enough Minerals
# --------------------
# I hate this one. It's another depth first search NP hard
# problem but unlike the last one its still very slow to
# run even with branch cutting. I think that's a bit of a fail.
#
sub runBlueprint {

    my $it = [];
    my $seen = {};
    my $geomax = -1;

    # Loop Invariants
    my $maxor = max($prices->{'or'}->{'or'},$prices->{'cl'}->{'or'},$prices->{'ob'}->{'or'},$prices->{'ge'}->{'or'});

    # Time_Robots_Swag
    push(@{$it}, [24,1,0,0,0,0,0,0,0]);

    while (@{$it})
    {
        my ($time,$ror,$rcl,$rob,$rge,$sor,$scl,$sob,$sge) = @{pop(@{$it})};

        # Check for winners when time is up
        if ($time == 0)
        {
            if ($geomax < $sge) {
                $geomax = $sge;
                printf("Iteration finished with %s %s\n",join(':',$ror,$rcl,$rob,$rge),join(':',$sor,$scl,$sob,$sge));
            }
            next;
        }

        # Branch Cut: If we end up in the same place then no point doing it again.
        $sig = join('_',$time,$ror,$rcl,$rob,$rge,$sor,$scl,$sob,$sge);
        next if exists $seen->{$sig};
        $seen->{$sig} = 1;

        # Branch Cut: If we can't match the best score with a theoretical new geode
        #   robot every cycle then forget it.
        $triangle = ($time * ($time+1)) / 2;
        if (($sge + ($time * $rge) + $triangle) <= $geomax)
        {
            next;
        }

        # Perm1: The buy nothing permutation
        push(@{$it}, [$time-1,$ror,$rcl,$rob,$rge,$sor+$ror,$scl+$rcl,$sob+$rob,$sge+$rge]);

        # Perm2: Buy an ORE robot
        if (($sor >= $prices->{'or'}->{'or'}) && ($ror < $maxor))
        {
            push(@{$it}, [$time-1,
                $ror+1,
                $rcl,
                $rob,
                $rge,
                $sor+$ror-$prices->{'or'}->{'or'},
                $scl+$rcl,
                $sob+$rob,
                $sge+$rge]);            
        }

        # Perm3: Buy a CLAY robot
        if (($sor >= $prices->{'cl'}->{'or'}) && ($rcl < $prices->{'ob'}->{'cl'}))
        {
            push(@{$it}, [$time-1,
                $ror,
                $rcl+1,
                $rob,
                $rge,
                $sor+$ror-$prices->{'cl'}->{'or'},
                $scl+$rcl,
                $sob+$rob,
                $sge+$rge]);            
        }

        # Perm4: Buy an obsidian robot
        if (($sor >= $prices->{'ob'}->{'or'}) && ($scl >= $prices->{'ob'}->{'cl'}) && ($rob < $prices->{'ge'}->{'ob'}))
        {
            push(@{$it}, [$time-1,
                $ror,
                $rcl,
                $rob+1,
                $rge,
                $sor+$ror-$prices->{'ob'}->{'or'},
                $scl+$rcl-$prices->{'ob'}->{'cl'},
                $sob+$rob,
                $sge+$rge]);            
        }

        # Perm5: Buy a GEODE robot
        if (($sor >= $prices->{'ge'}->{'or'}) && ($sob >= $prices->{'ge'}->{'ob'}))
        {
            push(@{$it}, [$time-1,
                $ror,
                $rcl,
                $rob,
                $rge+1,
                $sor+$ror-$prices->{'ge'}->{'or'},
                $scl+$rcl,
                $sob+$rob-$prices->{'ge'}->{'ob'},
                $sge+$rge]);            
        }
    }

    return $geomax;
}


while (<>)
{
    # The robots are always ordered the same and priced in the same
    # relative currencies so input can be reduced to set of positive numbers
    ($junk,$index,$ror,$rcl,$rob,$rob_cl,$rge,$rge_ob) = split /[^\d]+/, $_;
 
    # Prices of the robots, some cost multiple types of gems, some don't.
    $prices = {};
    $prices->{'or'}->{'or'} = $ror;
    $prices->{'cl'}->{'or'} = $rcl;
    $prices->{'ob'}->{'or'} = $rob;
    $prices->{'ob'}->{'cl'} = $rob_cl;
    $prices->{'ge'}->{'or'} = $rge;
    $prices->{'ge'}->{'ob'} = $rge_ob;

    ++$line;
    $bp->{$line} = runBlueprint();
    $acc += ($line * $bp->{$line});

    printf("Blueprint $line : %d %d\n", $bp->{$line}, $acc);
}
