#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $solution1 = "";
my $solution2 = "";

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
