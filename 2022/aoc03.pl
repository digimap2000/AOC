#!/usr/bin/perl
#
# RUCKSACK REORGANISATION
#
# This one leans heavily on regex searches for one
# string inside another. When negated this just leaves
# behind the common characters. 
#

#
# Dragged this out into a sub as it's common to both
# parts and a bit manky in how they specced the scoring.
#
sub score {
    return ord(@_[0]) - ((@_[0] =~ /[a-z]/) ? ord('a')-1 : ord('A')-27)    
}

#
# Doing both parts in a single file parse since it is 
# quite simple. Part1 second as it is desctructive
while (<>)
{
    ($line = ++$line % 3) && chomp;

    # Part 2 - Rolling accumulator of common characters 
    #   accross groups of three rucksacks.
    ($line == 1) && ($group = $_);
    ($line != 1) && ($group =~ s/[^$_]//g);
    ($line == 0) && ($part2 += score($group));

    # Part 1 - Totting up the scores for the one letter
    #   found in both rucksack compartments.
    $half = substr($_,0,length($_)/2);    
    $part1 += score(s/[^$half]//g && chop());
}
print $part1 . "\n";
print $part2 . "\n";

