#!/usr/bin/perl
use List::MoreUtils qw(uniq);

$_ = <>;
while (uniq(split(//,substr($_,$index++,$ARGV[0]))) != $ARGV[0]) {}
print $index+$ARGV[0]-1 . "\n";

