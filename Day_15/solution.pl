#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $solution1     =   0;
my $solution2     =   0;

my $CAPACITY      =   0;
my $DURABILITY    =   1;
my $FLAVOUR       =   2;
my $TEXTURE       =   3;
my $CALORIES      =   4;

my $TOTAL         = 100;
my $CALORY_AMOUNT = 500;

my $cookies;

while (<$fh>) {
    /^\pL+: \s+ capacity   \s+ (-?[0-9]+),
            \s+ durability \s+ (-?[0-9]+),
            \s+ flavor     \s+ (-?[0-9]+),
            \s+ texture    \s+ (-?[0-9]+),
            \s+ calories   \s+ (-?[0-9]+)/x
            or die "Failed to parse $_";
    push @$cookies => [$1, $2, $3, $4, $5];
}

#
# We only have four ingredients, so we can just brute force the possibilities
#
my @amounts;
for ($amounts [0] = 0; $amounts [0] <= $TOTAL; $amounts [0] ++) {
    my $left0 = $TOTAL - $amounts [0];
    for ($amounts [1] = 0; $amounts [1] <= $left0; $amounts [1] ++) {
        my $left1 = $left0 - $amounts [1];
        for ($amounts [2] = 0; $amounts [2] <= $left1; $amounts [2] ++) {
            $amounts [3] = $TOTAL - $amounts [0] - $amounts [1] - $amounts [2];
            my @properties = (0) x 4;
            my $calories   =  0;
            for (my $i = 0; $i < @$cookies; $i ++) {
                for (my $j = 0; $j < @properties; $j ++) {
                    $properties [$j] += $amounts [$i] * $$cookies [$i] [$j];
                }
                $calories += $amounts [$i] * $$cookies [$i] [$CALORIES];
            }
            for (my $j = 0; $j < @properties; $j ++) {
                $properties [$j] = 0 if $properties [$j] < 0;
            }
            my $total  = 1;
               $total *= $_ for @properties;
            if ($solution1 < $total) {
                $solution1 = $total;
            }
            if ($calories == $CALORY_AMOUNT) {
                if ($solution2 < $total) {
                    $solution2 = $total;
                }
            }
        }
    }
}

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
