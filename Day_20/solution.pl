#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $TARGET = $ARGV [0] // 34000000;

my $solution1 = 0;
my $solution2 = 0;

$| = 1;

#
# What we need is the sum of the divisors to be $TARGET / 10.
# We could make use of a sieve, but let's keep it simple.
#
my $house = 1;
while (1) {
    my $sqrt = int sqrt $house;
    my $presents1 = 0;
    my $presents2 = 0;
    for (my $i = 1; $i <= $sqrt; $i ++) {
        next if $house % $i;
        unless ($solution1) {
            $presents1 += 10 * $i;
            $presents1 += 10 * ($house / $i) unless $i ** $i == $house;
        }

        unless ($solution2) {
            $presents2 += 11 * $i if ($house / $i) <= 50;
            $presents2 += 11 * ($house / $i) if $i <= 50 && $i ** $i != $house;
        }
    }
    if ($presents1 >= $TARGET) {
        $solution1 ||= $house;
    }
    if ($presents2 >= $TARGET) {
        $solution2 ||= $house;
    }
    last if $solution1 && $solution2;
    $house ++;
}


say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

__END__
