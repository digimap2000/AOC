#!/usr/bin/perl

while (<>)
{
    @coords = split(' -> ', $_);

    ($x,$y) = split ',', shift(@coords);
    $cave->{$x}->{$y} = '#';

    while (scalar(@coords))
    {
        ($x2,$y2) = split ',', shift(@coords);
        while (($x2 != $x) || ($y2 != $y))
        {
            ($x != $x2) && ($x+=(($x>$x2)?-1:+1));       
            ($y != $y2) && ($y+=(($y>$y2)?-1:+1));       
            $cave->{$x}->{$y} = '#';
            ($y > $ymax) && ($ymax = $y);
        }
    }
}

do {
    $sx = 500;
    $sy = 0;
    $sand++;
    do {
        $motion = 0;
        @loc = (0,+1,-1);
        while (!$motion && @loc)
        {
            $x = pop(@loc);
            $motion = (not defined $cave->{$sx+$x}->{$sy+1});
            $sx += $motion ? $x : 0;
            $sy += $motion ? 1 : 0;
        }
    } while ($motion && ($sy < ($ymax+1)));
    $cave->{$sx}->{$sy} = 'o';
} while($sy != 0);
print $sand;


