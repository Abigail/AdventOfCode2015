#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = "input";

open my $fh, "<", $input;

my $nice1 = 0;
my $nice2 = 0;
while (<$fh>) {
    $nice1 ++ if /[aeiou].*[aeiou].*[aeiou]/ &&
                 /(.)\1/                     &&
                !/ab|cd|pq|xy/;
    $nice2 ++ if /(..).*\1/ && /(.).\1/;
}

say "Solution to part1: $nice1";
say "Solution to part2: $nice2";

__END__
