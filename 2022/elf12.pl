#!/usr/bin/perl


use Data::Dumper;

$stride = 171;
$rows = 41;
#$stride = 8;
#$rows = 5;

while (<>) {
    chomp();
    $m .= $_;
}

$start = (index($m,'E'));
$end = (index($m,'S'));
$steps->{$start} = 1;

$m =~ s/S/a/;
$m =~ s/E/z/;

do 
{
    $mods = 0;
    for $me (0..(($stride*$rows)-1))
    {
        if (exists $steps->{$me})
        {
            $s = $steps->{$me} + 1;

            @n = ();
            (($me % $stride) != 0) && push(@n,$me-1);
            (($me % $stride) != ($stride-1)) && push(@n,$me+1);
            (($me / $stride) >= 1) && push(@n,$me-$stride);
            (($me / $stride) < ($rows-1)) && push(@n,$me+$stride);

            foreach (@n)
            {
                $h1 = substr($m,$_,1);
                $h2 = substr($m,$me,1);

                #print ord($h1) . " vs " . ord($h2);

                if ((ord($h2) - ord($h1)) le 1)
                {
                    #print "FOO" . "\n";
                    if ((not exists $steps->{$_}) || ($steps->{$_} gt $s))
                    {
                        #print $_ . " " . $me . " " . $steps->{$_} . " " . $s . "\n";
                        $steps->{$_} = $s;
                        $mods++;
                    }
                }
            }            
        }
    } 

    #print $steps->{0} . " " . $steps->{1} . "\n";  

    print "MODS: " . $mods . "\n"; 
} while ($mods);

foreach (sort keys $steps)
{
    if (substr($m,$_,1) eq 'a')
    {
        $ajs->{$steps->{$_}} = 1;
        print $_ . " -> " . $steps->{$_} . "\n";
    }
}

print sort keys $ajs;

#print Dumper($steps);
print $steps->{$end}-1;




