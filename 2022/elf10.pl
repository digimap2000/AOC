#!/usr/bin/perl
while (<>) {
    ($opcode, $immediate) = $_ =~ /^([\S]+)\W{0,1}([\-0-9]*)/;
    for $c (1..(($opcode eq 'addx') ? 2 : 1)) {
        $crt .= ((abs(($i%40)-($x+1)) <= 1) ? '#' : '.');
        ($c eq 2) && ($x+=$immediate);
        (((++$i-19) % 40) eq 0) && ($tot += ($x+1) * ($i+1));
    }
}
print join("\n",$crt =~ /.{39}.?/g) . "\n" . $tot . "\n";
