
use Data::Dumper;

my $vars = {};
my @eq;

sub clear {
    $vars = {};
    foreach (0..44) {
        $vars->{"x0" . $_} = 0 if $_ < 10;
        $vars->{"x" . $_} = 0 if $_ >= 10;
        $vars->{"y0" . $_} = 0 if $_ < 10;
        $vars->{"y" . $_} = 0 if $_ >= 10;
    }
}

sub solve {
    my ($e) = @_;
    $e =~ /^([a-z0-9]+) ([A-Z]+) ([a-z0-9]+) -> ([a-z0-9]+)$/;
    return 0 unless (defined $vars->{$1} && defined $vars->{$3}); 
    my $opA = int($vars->{$1});
    my $opB = int($vars->{$3});
    $vars->{$4} = ($opA | $opB) if ($2 eq 'OR');
    $vars->{$4} = ($opA & $opB) if ($2 eq 'AND');
    $vars->{$4} = ($opA ^ $opB) if ($2 eq 'XOR');
    return 1;
}

sub execute {
    my ($swa,$swb) = @_;
    my @copy = @eq;

    if ($swa ne $swb) {
        my @a = split(" -> ",@copy[$swa]);
        my @b = split(" -> ",@copy[$swb]);
        @copy[$swa] = join(" -> ", (@a[0],@b[1]));
        @copy[$swb] = join(" -> ", (@b[0],@a[1]));
    }

    while (@copy) {
        my $count = scalar(@copy);
        foreach (0..$count-1) {
            my $e = pop(@copy);
            unshift(@copy, $e) unless solve($e);
        }
        last if $count eq scalar(@copy);
    }
    my $acc = 0;
    foreach (sort keys %$vars) {
        next unless $_ =~ /^z(\d+)$/;
        next if $vars->{$_} eq 0;
        $acc += (2 ** int($1));
    }
    return $acc;
}

sub bitname {
    my ($xy,$bit) = @_;
    return ($xy . $bit) if $bit >= 10;
    return ($xy . "0" . $bit);
}

sub checkbit {
    my ($bit,$swa,$swb) = @_;
    my $xk = bitname("x",$bit);
    my $yk = bitname("y",$bit);

    # X . Y . Cin . Out
    my @tests = ([0,0,0,0],[0,1,0,1],[1,0,0,1],[1,1,0,0],[0,0,1,1],[0,1,1,0],[1,0,1,0],[1,1,1,1]);
    foreach $t (@tests) {
        my ($x,$y,$c,$o) = @$t;
        clear();
        $vars->{bitname("x",$bit)} = $x;
        $vars->{bitname("y",$bit)} = $y;
        $vars->{bitname("x",$bit-1)} = $c if ($bit > 0);
        $vars->{bitname("y",$bit-1)} = $c if ($bit > 0);

        next if $c && ($bit eq 0);

        my $value = ((execute($swa,$swb) >> $bit) & 0x1);

#        print join('-',$x,$y,$c,$o,$value) . "\n";

        return 0 unless $value eq $o;
    }
    return 1;
}

sub smash {
    my ($bit) = @_;
    foreach $i (0..scalar(@eq)-1) {
        print $i . "\n";
        foreach $j (($i+1)..scalar(@eq)-1) {
            print ("OMG" . $i . " x " . $j . "\n") if checkbit($bit,$i,$j);
        }
    }
}

sub swappy {
    my ($x,$y) = @_;
    my @a = split(" -> ", @eq[$x]);
    my @b = split(" -> ", @eq[$y]);
    @eq[$x] = join(" -> ", (@a[0],@b[1]));
    @eq[$y] = join(" -> ", (@b[0],@a[1]));
}

while (<>) {
    chomp();
    $vars->{$1} = $2, next if $_ =~ /^([a-z0-9]*): (\d)$/;
    push(@eq, $_) if $_;
}

$p1 = execute();

#smash(36);
#exit;

# BIT 5
swappy(75,144);

# BIT 18
#swappy(9,42);
swappy(9,86);

# BIT 22
swappy(37,49);

# BIT 36
swappy(0,107);
#swappy(107,128);
#swappy(107,208);


@p2 = ();
foreach (0,107,37,49,9,86,75,144) {
    my ($a,$b) = split(" -> ",@eq[$_]);
    push(@p2, $b);
}
print join(',',(sort @p2)) . "\n";

exit;

foreach (0..44) {
    clear();
    print $_ . " => " . (checkbit($_) ? "OK" : "FAIL") . "\n";
}


print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";

print scalar(@eq);