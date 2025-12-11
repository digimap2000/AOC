
use Data::Dumper;

sub iterate {
    my ($target,$current,$button) = @_;
    foreach my $pos (split(',',$button)) {
        my $char = substr($current,$pos,1);
        substr($current,$pos,1,$char eq '.' ? '#' : '.');
    }
    return $current;
}

sub solve {
    my ($level, @solutions) = @_;

    print "==========\n LEVEL $level \n==========\n";

    my @candidates;
    foreach (@solutions) {
        my ($target,$current,@buttons) = @{$_};
        foreach (0..scalar(@buttons)-1) {
            my $result = iterate($target,$current,@buttons[$_]);
            my @remain = @buttons;
            splice(@remain,$_,1);
            print "$target ==> $result ==> " . join('   ',@remain) . "\n";

            if ($target eq $result)
            {
                return ();
            }

            push(@candidates, [$target, $result, @remain]);
        }
    }

    return @candidates;
}

while (<>) {
    chomp($_);

    my $target;
    my @buttons;
    my $joltage;
    foreach (split(' ',$_)) {
        $target = $1 if $_ =~ /\[(.*)\]/;
        push(@buttons,$1) if $_ =~ /\((.*)\)/;
        $joltage = $1 if $_ =~ /\{(.*)\}/;
    }

    my $level = 0;
    my $current = $target;
    $current =~ s/\#/\./g;
    my @candidates = ([$target,$current,@buttons]);
    while ($level < 20)
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
