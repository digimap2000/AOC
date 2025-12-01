my ($dial,$p1,$p2) = (50,0,0);
while (<>) {
    /^(\w)(\d+)/;
    for (1..abs($2))
    {
      $dial += ($1 eq 'R' ? 1 : -1);
      $p2++ unless $dial % 100;
    }
    $p1++ if ($dial % 100) == 0;
}
print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";