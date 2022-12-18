#!/usr/bin/perl
use Data::Dumper;

while (<>) {
    chomp();
    $rows++;
    $cols = length($_);
    $trees .= $_;
}

for ($p=0; $p<4; $p++) {
    for ($r=0; $r<$rows; $r++)
    {
        $line = '';
        $tallest = -1;
        for ($c=0; $c<$cols; $c++)
        {
            ($p eq 0) && ($index = $r*$rows + $c);
            ($p eq 1) && ($index = $r*$rows + ($cols - 1 - $c));
            ($p eq 2) && ($index = $c*$rows + $r);
            ($p eq 3) && ($index = ($cols - 1 - $c)*$rows + $r);

            $height = substr($trees,$index,1);
            if ($height > $tallest)
            {
                $tallest = $height;
                $visible->{$index}++;    
            }    

            $score = 0;
            $line = $line . $height;
            for ($i=length($line)-1; $i>0; $i--)
            {
                if ($height >= substr($line,$i,1))
                {
                    $score++;
                    if ($height eq substr($line,$i-1,1))
                    {
                        $i = 0;
                    }
                }
            }

            if (exists $scenic->{$index}) {
                $scenic->{$index} *= $score;
            } else {
                $scenic->{$index} = $score;
            }
        }
    }
}
print "Hidden Trees = " . scalar(keys $visible) . "\n";
print "Most scenic = " . $scenic->{(sort {$scenic->{$b} <=> $scenic->{$a}} keys $scenic)[0]} . "\n";



