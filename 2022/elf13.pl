#!/usr/bin/perl

sub splitty {
    my $s = @_[0];
    my $acc = '';
    my $index = 0;
    my @result = ();
    foreach (split //, $s)
    {
        $_ eq '[' && $index++;
        $_ eq ']' && $index--;
        if (($_ eq ',') && ($index == 0))
        {
            push(@result, $acc);
            $acc = '';
        }
        else
        {
            $acc .= $_;
        }
    }
    push(@result, $acc);
    return @result;
}

sub compare {
    my @left = splitty(@_[0]);
    my @right = splitty(@_[1]);
    while (@left)
    {
        my $l = shift(@left);
        my $r = shift(@right);
        if (($l =~ /^\[.*\]$/) || ($r =~ /^\[.*\]$/))
        {
            $l =~ s/^\[//g;
            $r =~ s/^\[//g;
            $l =~ s/\]$//g;
            $r =~ s/\]$//g;
            my $r = compare($l, $r);
            if ($r ne 0)
            {
                return $r;
            }
        }
        else
        {
            ($r < $l) && return -1;
            ($l < $r) && return +1;
        }
        return -1 if (@right == 0) && (@left != 0);
    }
    return (scalar(@right) != 0) ? 1 : 0;
}

sub zort {
    return compare($a,$b);
}

push(@lines,("[2]","[6]",""));
while (<>)
{
    chomp();
    if ($_ ne '')
    {
        ($_ =~ /^\[(.*)\]$/);
        push(@lines, $1);
    }
}

@sorted = reverse sort zort @lines;
for $i (1..(@sorted))
{
    if (@sorted[$i] eq "[2]")
    {
        print $i . "\n";
    }
    if (@sorted[$i] eq "[6]")
    {
        print $i . "\n";
    }
}
