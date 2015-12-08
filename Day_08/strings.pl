#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = "input";
open my $fh, "<", $input;

my $size1 = 0;
my $size2 = 0;

while (<$fh>) {
    s/^\s+//;
    s/\s+$//;
    my $original_string = $_;
    $size1 += length;
    s/^"// or die "'$_' does not start with a double quote";
    s/"$// or die "'$_' does not end with a double quote";

    s/\\\\|\\"|\\x[a-f0-9]{2}/./gi;

    $size1 -= length;

    $size2 -= length ($original_string);
    $original_string =~ s/(["\\])/\\$1/g;
    $original_string = qq ["$original_string"];
    $size2 += length ($original_string);
}

say "Solution of part1: $size1";
say "Solution of part2: $size2";
