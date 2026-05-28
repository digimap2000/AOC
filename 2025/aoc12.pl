
use Data::Dumper;

my $alpha = "abcdefghijklmbop";
my $constraints = {};
my @a = ();
my $p = {};
my $p1 = 0;
my $p2 = 0;

sub rotate {
    my ($shape, $rotation) = @_;

    # 0 1 2    6 3 0   8 7 6   2 5 8
    # 3 4 5    7 4 1   5 4 3   1 4 7
    # 6 7 8    8 5 2   2 1 0   0 3 6

    my @trans = ([6,3,0,7,4,1,8,5,2],[8,7,6,5,4,3,2,1,0],[2,5,8,1,4,7,0,3,6]);

    return $shape if $rotation eq 0;

    my $rotated;
    my $t = @trans[$rotation-1];
    foreach (@{$t}) {
        $rotated .= substr($shape,$_,1);
    }
    return $rotated;
}

sub apply {
    my ($x,$y,$w,$h,$id,$shape) = @_;
    my $count = 0;
    foreach (split('',$shape)) {
        my $yy = $y + int($count / 3) - 1;
        my $xx = $x + $count % 3 - 1;
        $count++;
        next unless $_ eq '#';
        my $cell = ($yy * $w) + $xx;
        push (@{$constraints->{$cell}}, "$id");
    }
}

sub genconstraints {
    my ($w,$h) = @_;
    foreach (sort keys %{$p}) {
        my $char = substr($alpha,$_,1);
        my $var = 0;
        foreach my $y (1..$h-2) {
            foreach my $x (1..$w-2) {
                my $seen = {};
                foreach my $rotation (0..3) {
                    my $rotated = rotate($p->{$_}, $rotation);
                    apply($x,$y,$w,$h,$char . $var,$rotated); # unless defined $seen->{$rotated};
                    $seen->{$rotated} = 1;
                    $var++;
                }
            }
        }
    }
}

sub writeconstraints {
    my ($w,$h,@counts) = @_;
    open(FH, '>', "constraints.txt") or die $!;

    foreach (sort {$a <=> $b} keys %{$constraints})
    {
        print FH join('+',@{$constraints->{$_}}) . "<=1\n";
    }

    my $perms = ($w-2) * ($h-2) * 4;
    my $char = 0;
    foreach (@counts) {
        my @concat = ();
        my $char = substr($alpha,$char++,1);
        foreach (0..$perms-1) {
            push(@concat,$char . $_);
        }
        print FH join('+',@concat) . "=$_\n";
    }
}

while (<>) {
    chomp($_);
    push(@a, [$1,split(' ',$2)]), next if $_ =~ /^(\d+x\d+): ([0-9 ]*)$/;

    $index = '', next unless $_;
    $index = $1, next if $_ =~ /^(\d+):$/;
    $p->{$index} .= $_;
}

my $testcount = 0;
foreach (@a) 
{
    $constraints = {};
    my ($area,@counts) = @{$_};
    my ($w,$h) = split('x',$area);

    my $totalcells = $w * $h;
    my $shapecells = 0;
    foreach (@counts) {
        $shapecells += ($_ * 7);
    }

    my $resolves = 0;
    if ($shapecells <= $totalcells)
    {
        genconstraints($w,$h);
        writeconstraints($w,$h,@counts);

        my $output = `source venv/bin/activate && python aoc12.py`;

        foreach (split(/\n/,$output))
        {
            $resolves = 1,last if $_ =~ /OPTIMAL/; 
        }
    }
    print "Test $testcount " . join('-',@counts) . " " . (($resolves eq 1) ? "PASS" : "FAIL") . "\n";
    $testcount++;
    $p1 += $resolves;
}

print "Part One: " . $p1 . "\n";   # 1533
print "Part Two: " . $p2 . "\n";   # 10733529153890

