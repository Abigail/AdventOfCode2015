#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $line = <$fh>;

my ($target_row, $target_col) = $line =~ /([0-9]+)/g;

my $start  = 20151125;
my $factor =   252533;
my $modulo = 33554393;

my $next = $start;
my $row  =  1;
my $col  =  1;

while ($row != $target_row || $col != $target_col) {
    $next *= $factor;
    $next %= $modulo;
    if ($row == 1) {
        $row = $col + 1;
        $col = 1;
    }
    else {
        $row --;
        $col ++;
    }
}

my $solution1 = $next;
my $solution2 = 0;

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
