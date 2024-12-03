use Data::Dumper;

sub validate {
    for ($i=1; $i<scalar(@_)-1; $i++)
    {
        $da = @_[$i]-@_[$i-1];
        $db = @_[$i+1]-@_[$i];
        return 0 if (abs($da) > 3) || (abs($db) > 3) || (($da * $db) <= 0);
    }
    return 1;    
}

while (<>)
{
    @r = split(/ /, $_);
    for ($j=-1; $j<scalar(@r); $j++)
    {
        @x = @r;
        splice(@x, $j, 1) unless $j<0;
        $p1++ if $j<0 && validate(@x);
        $p2++, last if validate(@x);            
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";