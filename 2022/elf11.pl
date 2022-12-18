#!/usr/bin/perl

use Data::Dumper;

$pf = 1;
while (<>) {
    chomp();
    $_ =~ s/\s*//g;

    if ($_ =~ /Monkey(\d+):/)
    {
        $monkey = $1;
    }

    elsif ($_ =~ /Startingitems:(.*)/)
    {
        $m->{$monkey}->{'items'} = [split(',',$1)];
    }

    elsif ($_ =~ /Operation:new=old([+*]{1})(.*)/)
    {
        $m->{$monkey}->{'opcode'} = $1;
        $m->{$monkey}->{'operand'} = $2;
    }

    elsif ($_ =~ /Test:divisibleby(\d+)/)
    {
        $pf *= $1;
        $m->{$monkey}->{'test'}->{'div'} = $1;
    }

    elsif ($_ =~ /If(true|false):throwtomonkey(\d+)/)
    {
        $m->{$monkey}->{'test'}->{$1} = $2;
    }
}

foreach $round (1..10000)
{
    foreach (sort keys $m) {
        $rules = $m->{$_};
        foreach $item (@{$rules->{'items'}})
        {          
            $rules->{'tally'}++;

            $num = ($rules->{'operand'} eq 'old') ? $item : $rules->{'operand'};
            if ($rules->{'opcode'} eq '*')
            {
                $worry = $item * $num;
            }
            else
            {
                $worry = $item + $num;
            }

            $worry = $worry % $pf;

#            $worry = int($worry / 3);

            $recipient = ($worry % $rules->{'test'}->{'div'}) 
                ? $rules->{'test'}->{'false'}
                : $rules->{'test'}->{'true'};

            push(@{$m->{$recipient}->{'items'}}, $worry);

        }
        $rules->{'items'} = [];
    }

    print "ROUND " . $round . "\n";
    foreach (sort keys $m) {
        print "Monkey " . $_ . ":" . join(', ', @{$m->{$_}->{'items'}}) . "\n";
    }
    print "\n";
}

foreach (sort keys $m) {
    print "Monkey " . $_ . ":" . $m->{$_}->{'tally'} ."\n";
}





