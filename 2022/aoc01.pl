#!/usr/bin/perl
use List::Util qw/sum/;

#
# A fiendish exercise in slurping files. Since the rucksacks are
# demarqued by blank lines we can overwrite the readline splitter
# to fetch entire rucksacks at a time. Then it's simple enough to
# split and sum the calories to produce a list of the rucksack sizes.
#
for (do { local $/ = "\n\n"; <> }) {
    push(@cal, sum(split /\n/, $_));   
}

#
# And sorting this numerically can give us the largest rucksack or 
# the sum of the top rucksacks for part 2. 
#
printf("Part 1: %d\n", (reverse sort {$a <=> $b} @cal)[0]);
printf("Part 2: %d\n", sum((reverse sort {$a <=> $b} @cal)[0..2]));

