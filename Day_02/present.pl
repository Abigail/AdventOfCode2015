#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = "input";
open my $fh, "<", $input;


my $paper_needed  = 0;
my $ribbon_needed = 0;
while (<$fh>) {
    my ($l, $w, $h) = /^([0-9]+)x([0-9]+)x([0-9]+)$/ or failed to parse $_;
    my $f1 = $l * $w;
    my $f2 = $l * $h;
    my $f3 = $w * $h;
    #
    # Find the smallest face
    #
    my $f4 = $f1 < $f2 ? $f1 < $f3 ? $f1
                                   : $f3
                       : $f2 < $f3 ? $f2
                                   : $f3;
    $paper_needed += 2 * ($f1 + $f2 + $f3) + $f4;

    #
    # Find the perimetes of each face.
    #
    my $p1 = $l + $w;
    my $p2 = $l + $h;
    my $p3 = $w + $h;
    #
    # Find the smallest perimeter
    #
    my $p4 = $p1 < $p2 ? $p1 < $p3 ? $p1
                                   : $p3
                       : $p2 < $p3 ? $p2
                                   : $p3;
    $ribbon_needed += 2 * $p4;
    $ribbon_needed += $l * $w * $h;
}

say "Solution to part1: $paper_needed";
say "Solution to part2: $ribbon_needed";

__END__
