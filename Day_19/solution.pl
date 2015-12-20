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

my @mappings;
my $medicine;
my %seen;

while (<$fh>) {
    chomp;
    next unless /\S/;
    if (/^(\pL+)\s*=>\s*(\pL+)/) {
        push @mappings => [$1, $2];
    }
    else {
        if ($medicine) {
            die "Have already a medicine: $medicine\n";
        }
        $medicine = $_;
    }
}

foreach my $mapping (@mappings) {
    my ($from, $to) = @$mapping;
    while ($medicine =~ /$from/g) {
        $seen {$` . $to . $'} ++;
    }
}

$solution1 = keys %seen;

$| = 1;

#
# It seems a greedy solution (always try the left most longest match first),
# working backwards from the end medicine works. That won't be true in
# general, but it happens to be the case for the given input.
#
# Bad problem.
#
@mappings = sort {length $$b [1] <=> length $$a [1]} @mappings;

%seen = ();
sub try;
sub try {
    no warnings 'recursion';
    my ($steps, $molecule) = @_;
    $seen {$molecule} ++;
    if ($molecule eq 'e') {
        return $steps;
    }
    foreach my $mapping (@mappings) {
        my ($from, $to) = @$mapping;
        while ($molecule =~ /$to/g) {
            my $new = $` . $from . $';
            next if $seen {$new} ++;
            my $solution = try $steps + 1, $new;
            return $solution if $solution;
        }
    }
    return;
}

$solution2 = try 0, $medicine;

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
