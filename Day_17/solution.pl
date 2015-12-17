#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;
use List::Util 'sum', 'min';

my $TARGET = 150;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $solution1 = 0;
my $solution2 = 0;

my @solutions;
sub nr_of_ways {
    my ($target, $available, $used) = @_;
    return if $target <  0;
    if ($target == 0) {
        push @solutions => $used;
        return;
    }
    return if $target >  sum 0, @$available;
    my ($volume, @left) = @$available;
    nr_of_ways ($target - $volume, \@left, [@$used => $volume]);
    nr_of_ways ($target,           \@left,   $used);
}

my @volumes;
while (<$fh>) {
    chomp;
    push @volumes => $_;
}
@volumes = sort {$b <=> $a} @volumes;

nr_of_ways $TARGET, [@volumes], [];

$solution1 = @solutions;

#
# Of all solutions, find the one with the least number of containers.
#
my $min = min map {scalar @$_} @solutions;

$solution2 = grep {@$_ == $min} @solutions;


say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
