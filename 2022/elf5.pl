#!/usr/bin/perl

$piles = {};

open(FH, '<', 'elf.txt');
while (<FH>)
{        
    if ($_ =~ /\[/)
    {
        $index = 0;
        do {
            if (substr($_,$index*4,4) =~ /\[([A-Z]+)\]/)           
            {
                $piles->{$index+1} = $1 . $piles->{$index+1};
            }
        } while ((++$index*4) < length($_))
    }
    elsif ($_ =~ /move/)
    {
        s/move (\d+) from (\d+) to (\d+)//g;
        $num = $1;
        while($num--)
        {
            $piles->{$3} .= chop($piles->{$2});
        }
    }
}

foreach (sort keys $piles)
{
    print chop($piles->{$_});
}
print "\n";

