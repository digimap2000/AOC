#!/usr/bin/perl
use strict;

my $elf = 1;
my $cal = {};

open(FH, '<', 'elf.txt');
while (<FH>)
{
    $elf += (! /\S/) ? 1 : 0;
    $cal->{$elf} += int($_)
}

my $winner1 = (reverse sort {$cal->{$a} <=> $cal->{$b}} keys $cal)[0];
my $winner2 = (reverse sort {$cal->{$a} <=> $cal->{$b}} keys $cal)[1];
my $winner3 = (reverse sort {$cal->{$a} <=> $cal->{$b}} keys $cal)[2];

printf $cal->{$winner1} + $cal->{$winner2} + $cal->{$winner3};

