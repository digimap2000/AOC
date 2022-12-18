#!/usr/bin/perl

open(FH, '<', 'elf.txt');
while (<FH>)
{
    $a = substr($_,0,length($_)/2);    
    $_ = s/[^$a]//g && chop();
    $total += ord($_) - ((ord($_) > ord('Z')) ? ord('a')-1 : ord('A')-27);
}
print $total . "\n";