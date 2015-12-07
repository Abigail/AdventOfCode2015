#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = "input";

open my $fh, "<", $input;

my %houses1 = ();            # Track which houses have been seen, part1.
my %houses2 = ();            # Track which houses have been seen, part2.

local $/;                    # Slurp mode.
$_ = <$fh>;                  # Read entire input.
my ($s1_x, $s1_y) = (0, 0);  # Santa, part1 starts here.
my ($s2_x, $s2_y) = (0, 0);  # Santa, part2 starts here.
my ($sr_x, $sr_y) = (0, 0);  # Robot Santa, part2 starts here.
$houses1 {$s1_x, $s1_y} ++;
$houses2 {$s2_x, $s2_y} ++;
$houses2 {$sr_x, $sr_y} ++;

my $robo = 0;
while (/(.)/gs) {
    my $char = $1;
    if    ($char eq "<") {
        $s1_x -= 1;
        if ($robo) {$sr_x -= 1}
        else       {$s2_x -= 1}
    }
    elsif ($char eq ">") {
        $s1_x += 1;
        if ($robo) {$sr_x += 1}
        else       {$s2_x += 1}
    }
    elsif ($char eq "^") {
        $s1_y += 1;
        if ($robo) {$sr_y += 1}
        else       {$s2_y += 1}
    }
    elsif ($char eq "v") {
        $s1_y -= 1;
        if ($robo) {$sr_y -= 1}
        else       {$s2_y -= 1}
    }
    else {next}
    $houses1 {$s1_x, $s1_y} ++;
    if ($robo) {
        $houses2 {$sr_x, $sr_y} ++;
    }
    else {
        $houses2 {$s2_x, $s2_y} ++;
    }
    $robo = 1 - $robo;
}

printf "Solution to part1: %d\n", scalar keys %houses1;
printf "Solution to part2: %d\n", scalar keys %houses2;
