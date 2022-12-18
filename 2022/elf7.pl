#!/usr/bin/perl
use List::Util qw(sum);

while (<>)
{
    (/^\$ cd \.\.$/) && pop @dir && next;
    (/^\$ cd (.*)$/) && push @dir, join('/',@dir) . $1;
    if (/^(\d+) /) {
        foreach $d (@dir) {$fs->{$d} += $1}
    };
}

delete $fs->{$_} for grep { $fs->{$_} > 100000} keys($fs);
print sum values $fs;

