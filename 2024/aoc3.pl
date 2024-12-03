
$do = 1;
while (<>)
{
    $line = $_;
    while ($line =~ m/(mul|do|don't)\((\d*),{0,1}(\d*)\)(.*$)/)
    {
        $p1 += $2 * $3 if $1 eq 'mul';
        $p2 += $2 * $3 * $do if $1 eq 'mul';
        $do = 1 if $1 eq 'do';
        $do = 0 if $1 eq 'don\'t';
        $line = $4;
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";