#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';


my $needed = 0;
while (<>) {
    my ($l, $w, $h) = /^([0-9]+)x([0-9]+)x([0-9]+)$/ or failed to parse $_;
    my $f1 = $l * $w;
    my $f2 = $l * $h;
    my $f3 = $w * $h;
    #
    # Find the smallest
    #
    my $f4 = $f1 < $f2 ? $f1 < $f3 ? $f1
                                   : $f3
                       : $f2 < $f3 ? $f2
                                   : $f3;
    $needed += 2 * ($f1 + $f2 + $f3) + $f4;
}

say "Paper needed: $needed";

__END__
