#!/usr/bin/perl

#Parsing beacon positions
while (<>)
{
    ($sx,$sy,$bx,$by) = $_ =~ /^.*x=(-{0,1}\d+), y=(-{0,1}\d+).*x=(-{0,1}\d+), y=(-{0,1}\d+).*$/;
    push(@ax,$sx);
    push(@ay,$sy);
    push(@am,abs($sx - $bx) + abs($sy - $by));
}

#Recursive grid scanning
sub scan {
    my ($step,$xmin,$xmax,$ymin,$ymax) = @_;
    for (my $row=$xmin; $row<$xmax; $row+=$step) {
        for (my $col=$ymin; $col<$ymax; $col+=$step) {
            my $detected = 0;
            my $loop = scalar(@ax);
            while ($loop-- && !$detected)
            {
                my $sx = @ax[$loop];
                my $sy = @ay[$loop];
                my $distance = abs($sx - $row) + abs($sy - $col);
                (($distance+(2*($step-1))) <= (@am[$loop])) && ($detected = 1);
            }
            if (!$detected)
            {
                ($step == 1) && (print $row . "x" . $col . "\n") && exit;
                for my $j (0..9) {
                    for my $k (0..9) {
                        scan($step/10, 
                            $row+(($k+0)*$step/10),
                            $row+(($k+1)*$step/10),
                            $col+(($j+0)*$step/10),
                            $col+(($j+1)*$step/10));                                
                    }
                }
            }
        }
    }
}
scan(100000, 0, 4000000, 0, 4000000);
