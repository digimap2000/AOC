$row = 0;
while (<>)
{
    chomp();
    $col = 0;
    foreach (split(//,$_)) {
        $data->{$row}->{$col++} = $_;
    }
    $row++;
}

foreach $row (sort keys %$data)
{
    foreach $col (sort keys %{$data->{$row}})
    {
        $p1++ if $data->{$row}->{$col} eq 'X'
            && $data->{$row+1}->{$col} eq 'M'
            && $data->{$row+2}->{$col} eq 'A'
            && $data->{$row+3}->{$col} eq 'S';

        $p1++ if $data->{$row}->{$col} eq 'X'
            && $data->{$row-1}->{$col} eq 'M'
            && $data->{$row-2}->{$col} eq 'A'
            && $data->{$row-3}->{$col} eq 'S';

        $p1++ if $data->{$row}->{$col} eq 'X'
            && $data->{$row}->{$col+1} eq 'M'
            && $data->{$row}->{$col+2} eq 'A'
            && $data->{$row}->{$col+3} eq 'S';

        $p1++ if $data->{$row}->{$col} eq 'X'
            && $data->{$row}->{$col-1} eq 'M'
            && $data->{$row}->{$col-2} eq 'A'
            && $data->{$row}->{$col-3} eq 'S';

        $p1++ if $data->{$row}->{$col} eq 'X'
            && $data->{$row+1}->{$col+1} eq 'M'
            && $data->{$row+2}->{$col+2} eq 'A'
            && $data->{$row+3}->{$col+3} eq 'S';

        $p1++ if $data->{$row}->{$col} eq 'X'
            && $data->{$row-1}->{$col-1} eq 'M'
            && $data->{$row-2}->{$col-2} eq 'A'
            && $data->{$row-3}->{$col-3} eq 'S';

        $p1++ if $data->{$row}->{$col} eq 'X'
            && $data->{$row-1}->{$col+1} eq 'M'
            && $data->{$row-2}->{$col+2} eq 'A'
            && $data->{$row-3}->{$col+3} eq 'S';

        $p1++ if $data->{$row}->{$col} eq 'X'
            && $data->{$row+1}->{$col-1} eq 'M'
            && $data->{$row+2}->{$col-2} eq 'A'
            && $data->{$row+3}->{$col-3} eq 'S';

        $p2++ if $data->{$row}->{$col} eq 'A'
            && $data->{$row-1}->{$col+1} =~ /M|S/
            && $data->{$row+1}->{$col-1} =~ /M|S/
            && $data->{$row-1}->{$col-1} =~ /M|S/
            && $data->{$row+1}->{$col+1} =~ /M|S/
            && $data->{$row+1}->{$col+1} ne $data->{$row-1}->{$col-1} 
            && $data->{$row+1}->{$col-1} ne $data->{$row-1}->{$col+1}; 
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";