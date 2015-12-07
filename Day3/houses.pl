#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

my %houses = ();       # Track which houses have been seen.

local $/;              # Slurp mode.
$_ = <>;               # Read entire input.
my ($x, $y) = (0, 0);  # Santa starts here.
my $count = 0;
$houses {$x, $y} ++;
while (/(.)/gs) {
    my $char = $1;
    if    ($char eq "<") {$x -= 1}
    elsif ($char eq ">") {$x += 1}
    elsif ($char eq "^") {$y += 1}
    elsif ($char eq "v") {$y -= 1}
    else {next}
    $houses {$x, $y} ++;
}

printf "Santa visits %d houses\n" => scalar keys %houses;
