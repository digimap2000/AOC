use Data::Dumper;

my @map;

sub at {
    my ($x,$y) = @_;
    return $map[$y][$x];
}

sub find {
    foreach $y (0..scalar(@map)-1) {
        foreach $x (0..scalar(@{$map[$y]})-1) {
            return ($x,$y) if $map[$y][$x] eq '@';
        }
    }
    return (0,0);
}

sub printmap {
    foreach (@map) {
        print join('',@$_) . "\n";
    }
    print "\n";
}

sub score {
    my $acc = 0;
    foreach $y (0..scalar(@map)-1) {
        foreach $x (0..scalar(@{$map[$y]})-1) {
            $acc += ($x + $y*100) if $map[$y][$x] =~ /O|\[/;
        }
    }
    return $acc;
}

sub move {
    my ($x,$y,$dx,$dy) = @_;    

    my @o = ([0,$x,$y]);
    foreach my $it (1..1000) {
        my @new = ();
        foreach (@o)
        {
            my ($ss,$xx,$yy) = @$_;
            next unless $ss eq ($it-1);

            my $cell = at($xx + $dx, $yy + $dy);
            return if $cell eq '#';
            push(@new,([$it, $xx + $dx, $yy + $dy])) if $cell =~ /O|\[|\]/;
            if (($cell eq '[') && ($dx eq 0)) {
                push(@new,([$it, $xx + $dx + 1, $yy + $dy]));
            }            
            if (($cell eq ']') && ($dx eq 0)) {
                push(@new,([$it, $xx + $dx - 1, $yy + $dy]));
            }            
        }
        last unless scalar (@new);
        foreach (@new) {
            push(@o,$_);
        }
    }
    print Dumper (@o);

    # Move selected items one position in dx/dy
    my $moved = {};
    while (@o) {
        $n = pop(@o);
        next if $moved->{@$n[1]}->{@$n[2]};
        $moved->{@$n[1]}->{@$n[2]}++;
        $map[@$n[2] + $dy][@$n[1] + $dx] = $map[@$n[2]][@$n[1]];
        $map[@$n[2]][@$n[1]] = '.';
    }
}

$limit = 10;
while (<>) {
    chomp();
    if ($_ =~ /#/)
    {
#        push (@map, [split(//,$_)]);
#        next;

        my $line = [];
        foreach (split(//,$_)) {        
            push(@$line, ('#','#')) if $_ eq '#';
            push(@$line, ('.','.')) if $_ eq '.';
            push(@$line, ('[',']')) if $_ eq 'O';
            push(@$line, ('@','.')) if $_ eq '@';
        }
        push (@map, $line);
        next;
    }
        printmap();
    foreach (split(//,$_)) {
        print "\n" . $_ . ":\n";
        move(find(),0,-1) if $_ eq '^';
        move(find(),0,+1) if $_ eq 'v';
        move(find(),-1,0) if $_ eq '<';
        move(find(),+1,0) if $_ eq '>';
        printmap();
#        exit unless $limit--;
    }
};

$p1 = score();

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";
