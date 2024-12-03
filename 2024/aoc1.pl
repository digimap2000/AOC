while (<>)
{
    /^(\d+)\s+(\d+)/;
    push(@a, $1);
    push(@b, $2);       # Part 1
    $c{$2}++;           # Part 2
}

@a = sort(@a);
@b = sort(@b);
while (@a)
{
    $z = pop(@a);
    $p1 += abs($z - pop(@b));
    $p2 += $c{$z} * $z;
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";