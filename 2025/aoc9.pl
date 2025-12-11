
use Math::Geometry::Planar;

my $p1, $p2;
my @points;

sub min {
    my ($a,$b) = @_;
    return $a < $b ? $a : $b;
}

sub max {
    my ($a,$b) = @_;
    return $a > $b ? $a : $b;
}

sub intersects {
    my ($x1,$y1,$x2,$y2) = @_;

    my $p1 = [$x1,$y1];
    my $p2 = [$x2,$y2];
    foreach (0..scalar(@points)-1)
    {
        my $p3 = @points[$_];
        my $p4 = @points[($_+1) % scalar(@points)];
        print "NOPE", return 1 if SegmentIntersection([$p1,$p2,$p3,$p4]);
    }
    return 0;
}

sub contains {
    my ($x1,$y1,$x2,$y2,$polygon) = @_;

    foreach my $x ($x1..$x2) {
        foreach my $y ($y1..$y2) {
            return 0 unless $polygon->isinside([$x,$y]);
        }
    }
    return 1;
}

sub biggest {
    my ($polygon) = @_;
    foreach my $x (0..scalar(@points)-1)
    {
        print "X=$x\n";
        foreach my $y ($x+1..scalar(@points)-1)
        {
            my $xmin = min(@points[$x]->[0], @points[$y]->[0]);
            my $xmax = max(@points[$x]->[0], @points[$y]->[0]);
            my $ymin = min(@points[$x]->[1], @points[$y]->[1]);
            my $ymax = max(@points[$x]->[1], @points[$y]->[1]);
            
            my $area = ($xmax-$xmin+1) * ($ymax-$ymin+1);
            next if $xmax eq $xmin;
            next if $ymax eq $ymin;

            # P1 is a straight biggest rectangle test
            $p1 = $area if $area > $p1;

            # P2 requires that the rectangle fits entirely in the outer shape
            my $ptest = Math::Geometry::Planar->new;
            $ptest->points([[$xmin,$ymin],[$xmin,$ymax],[$xmax,$ymax],[$xmax,$ymin]]);

            next unless $area > $p2;

#            next unless contains($xmin,$ymin,$xmin,$ymax,$polygon);
#            next unless contains($xmin,$ymax,$xmax,$ymax,$polygon);
#            next unless contains($xmax,$ymax,$xmax,$ymin,$polygon);
#            next unless contains($xmax,$ymin,$xmin,$ymin,$polygon);

            next if intersects($xmin,$ymin,$xmin,$ymax);
            next if intersects($xmin,$ymax,$xmax,$ymax);
            next if intersects($xmax,$ymax,$xmax,$ymin);
            next if intersects($xmax,$ymin,$xmin,$ymin);

            next unless $polygon->isinside([$xmin,$ymin]);
            next unless $polygon->isinside([$xmin,$ymax]);
            next unless $polygon->isinside([$xmax,$ymin]);
            next unless $polygon->isinside([$xmax,$ymax]);

            $p2 = $area;

        }
    }
}

while (<>) {
    chomp($_);
    push(@points, [split(',',$_)]);
}

my $polygon = Math::Geometry::Planar->new;
$polygon->points(\@points);

biggest($polygon);

print "Part One: " . $p1 . "\n";   # 1533
print "Part Two: " . $p2 . "\n";   # 10733529153890
