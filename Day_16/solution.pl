#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $solution1 = 0;
my $solution2 = 0;

my %matches = qw [
    children    3
    cats        7
    samoyeds    2
    pomeranians 3
    akitas      0
    vizslas     0
    goldfish    5
    trees       3
    cars        2
    perfumes    1
];


my @sues;
while (<$fh>) {
    /^Sue \s+ ([0-9]+): \s+ (.*)/x 
      or die "Failed to parse $_";
    my ($sue, $thingies) = ($1, $2);
    my @things = $thingies =~ /([a-z]+):\s*([0-9]+)/g;
    my $set = { };
    while (@things) {
        my $thing  = shift @things;
        my $amount = shift @things;
        $$set {$thing} = $amount;
    }
    $sues [$sue] = $set;
}

SUE:
for (my $sue = 0; $sue < @sues; $sue ++) {
    my $set = $sues [$sue] or next SUE;
    my $could_be_sue1 = 1;
    my $could_be_sue2 = 1;
    foreach my $thing (keys %$set) {
        $could_be_sue1 = 0 unless $$set {$thing} == $matches {$thing};
        if ($thing eq "cats" || $thing eq "trees") {
            $could_be_sue2 = 0 unless $$set {$thing} > $matches {$thing};
        }
        elsif ($thing eq "pomeranians" || $thing eq "goldfish") {
            $could_be_sue2 = 0 unless $$set {$thing} < $matches {$thing};
        }
        else {
            $could_be_sue2 = 0 unless $$set {$thing} == $matches {$thing};
        }
    }
    $solution1 = $sue if $could_be_sue1;
    $solution2 = $sue if $could_be_sue2;
    last if $solution1 && $solution2;
}

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
