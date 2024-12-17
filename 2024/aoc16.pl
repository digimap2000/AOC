use Data::Dumper;

my @v = ([1,0],[0,1],[-1,0],[0,-1]); # E S W N
my $cost = {};
my @map;

sub find {
    my ($w) = @_;
    foreach $y (0..scalar(@map)-1) {
        foreach $x (0..scalar(@{$map[$y]})-1) {
            return ($x,$y) if $map[$y][$x] eq $w;
        }
    }
    return (0,0);
}

my $limit = 100;
my $winning = 999999999;
my $winners = {};

sub explore {
    my ($x,$y,$v,$ex,$ey,$c,$path) = @_;
    return if $map[$y][$x] eq '#';

#    exit unless $limit--;

    return if $c > $winning;
    return if defined $cost->{$x}->{$y}->{$v} && ($cost->{$x}->{$y}->{$v} < $c);
    $cost->{$x}->{$y}->{$v} = $c;

    if (($x eq $ex) && ($y eq $ey))
    {
        return unless $c <= $winning;
        $winning = $c;
        $winners->{$c} .= $path;
        print "HIT: " . $c . " " . $v . $path . "\n";
        return;
    }

    foreach (0..3) {
        my $dir = ($v + $_) % 4;
        my ($dx, $dy) = (@{@v[$dir]}[0], @{@v[$dir]}[1]);

        my $newcost = $c + 1;
        $newcost += 1000 unless $_ eq 0;

        my $newpath = $path . "_" . ($x+$dx) . "x" . ($y+$dy);

        explore($x+$dx,$y+$dy,$dir,$ex,$ey,$newcost,$newpath);
    }
}



while (<>) {
    chomp(); 
    push (@map,[split(//,$_)]);
};

my ($sx,$sy) = find('S');
my ($ex,$ey) = find('E');

explore($sx,$sy,0,$ex,$ey,0),"";

print "\n";
#print Dumper ($winners->{$winning});
$p1 = $winning;

$cell = {};
foreach (split(/_/,$winners->{$winning}))
{
    $cell->{$_}++;
}
$p2 = (scalar keys %$cell);

print "Part One: " . $p1 . "\n"; # 79404
print "Part Two: " . $p2 . "\n"; # 451

# 69412 = too low
# 78411 = wrong
# 78412 = wrong!
# 79411 = too high
# 79412 = too high
