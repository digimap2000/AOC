use Math::Base::Convert qw( :all );

while (<>)
{
    chomp();
    /^(\d+):(.*)$/;
    @operands = split(' ',$2);
    $target = $1;

    my $valid = 0;
    my $count = scalar(@operands);
    my $max = (4 ** ($count-1));

    print $line++ . " " . $count . " = " . $max . " iterations\n";

    for ($i=0; $i<$max && $valid eq 0; $i++)
    {
        $foo = cnv($i, 10 => 5);
        print $foo . "\n";
        $bogus = 0;
        $res = @operands[0];
        for ($j=1; $j<$count; $j++)
        {
            my $mask = ($i >> (($j-1)*2)) & 0x3;
            $res = $res + @operands[$j] if $mask eq 0;
            $res = $res * @operands[$j] if $mask eq 1;
            $res = $res . @operands[$j] if $mask eq 2;
            $bogus = 1 if $mask eq 3;
        }
        $valid = 1 if $res eq $target && $bogus eq 0;
    }

    $p1 += $target if $valid;
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";