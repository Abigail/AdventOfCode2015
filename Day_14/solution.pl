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

my $RACE_TIME = 2503;

my $SPEED              = 0;
my $FLY_TIME           = 1;
my $REST_TIME          = 2;
my $DISTANCE_TRAVELLED = 3;
my $POINTS             = 4;

my $reindeer;
while (<$fh>) {
    m{^(\S+) \s+ can \s+ fly \s+ ([0-9]+) \s+ km/s \s+ for \s+ ([0-9]+) \s+
       seconds?, \s+ but \s+ then \s+ must \s+ rest \s+ for \s+ ([0-9]+)}x 
       or die "Failed to parse $_";
    push @$reindeer => [$2, $3, $4, 0, 0];
}

#
# For the second solution, we tick every second, move the reindeer
# (if they aren't flying), and award points.
#
for (my $second = 0; $second < $RACE_TIME; $second ++) {
    foreach my $reindeer (@$reindeer) {
        #
        # Do we fly?
        #
        if (($second % ($$reindeer [$FLY_TIME] + $$reindeer [$REST_TIME])) < 
                        $$reindeer [$FLY_TIME]) {
            $$reindeer [$DISTANCE_TRAVELLED] += $$reindeer [$SPEED]
        }
    }
    #
    # After moving the reindeer, find the one(s) in the lead.
    #
    my $max_travelled = 0;
    foreach my $reindeer (@$reindeer) {
        $max_travelled = $$reindeer [$DISTANCE_TRAVELLED] if
                         $$reindeer [$DISTANCE_TRAVELLED] > $max_travelled;
    }
    foreach my $reindeer (@$reindeer) {
        $$reindeer [$POINTS] ++ if $$reindeer [$DISTANCE_TRAVELLED] ==
                                                    $max_travelled;
    }
}

foreach my $reindeer (@$reindeer) {
    $solution1 = $$reindeer [$DISTANCE_TRAVELLED] if
                 $$reindeer [$DISTANCE_TRAVELLED] > $solution1;
    $solution2 = $$reindeer [$POINTS] if
                 $$reindeer [$POINTS] > $solution2;
}


say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
