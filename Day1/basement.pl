#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = "input";

open my $fh, "<", $input;
local $/;          # Slurp mode.
$_ = <$fh>;        # Read entire input.

my $floor = 0;
my $index = 0;
my $basement_entered;

while (/(.)/g) {
    my $char = $1;
    next unless $char =~ /[()]/;
    $index ++;
    if ($char eq '(') {$floor ++;}
    if ($char eq ')') {$floor --;}
    if (!$basement_entered && $floor < 0) {
        $basement_entered = $index;
    }
}


say "Solution to part1: $floor";
say "Solution to part2: $basement_entered";
