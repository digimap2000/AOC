
use Data::Dumper;

my $seen = {};

sub overflow {
    my ($a,$b) = @_;
    my @aa = split(',',$a);
    my @bb = split(',',$b);
    foreach (0..scalar(@aa)-1) {
        return 1 if @aa[$_] > @bb[$_];
    }
    return 0;
}

sub unique {
    my ($a,@list) = @_;
    foreach (@list)
    {
        return 0 if $a eq $_;
    }
    return 1;
}

sub iterate {
    my ($target,$current,$button) = @_;

    my @c = split(',',$current);

    foreach my $pos (split(',',$button)) {
        @c[$pos]++;
    }

    return join(',',@c);
}

sub solve {
    my ($level, @solutions) = @_;

    print "LEVEL $level " . scalar(@solutions) . " \n";

    my @candidates;
    foreach (@solutions) {
        my ($target,$current,@buttons) = @{$_};
        foreach (0..scalar(@buttons)-1) {
            my $result = iterate($target,$current,@buttons[$_]);
            if ($target eq $result)
            {
                return ();
            }

            next if overflow($result,$target);
            next if defined $seen->{$result};

            $seen->{$result}++;

            push(@candidates, [$target, $result, @buttons]);
            print "$level $target ==> $result ==> " . join('   ',@buttons) . "\n";
        }
    }

    return @candidates;
}

while (<>) {
    chomp($_);

    my $target;
    my @buttons;
    foreach (split(' ',$_)) {
#        $target = $1 if $_ =~ /\[(.*)\]/;
        push(@buttons,$1) if $_ =~ /\((.*)\)/;
        $target = $1 if $_ =~ /\{(.*)\}/;
    }

    my $level = 0;
    my $current = "0,0,0,0";
    my @candidates = ([$target,$current,@buttons]);
    while ($level < 14)
    {
        @candidates = solve(++$level, @candidates);
        if (scalar(@candidates) eq 0)
        {
            print ("Solution... $level\n");
            $p1 += $level;
            last;
        }
    }
}


print "Part One: " . $p1 . "\n";   # 
print "Part Two: " . $p2 . "\n";   # 
