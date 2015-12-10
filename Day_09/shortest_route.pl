#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = "input";
open my $fh, "<", $input;

my %map;
my @cities;

while (<$fh>) {
    /^(\S+) \s+ to \s+ (\S+) \s+ = \s+ ([0-9]+) \s* $/x
      or die "Failed to parse $_";
    my ($city1, $city2, $distance) = ($1, $2, $3);
    $map {$city1} {$city2} = $map {$city2} {$city1} = $distance;
}

@cities = keys %map;

#
# Just brute-force all possibilities. Using a CPAN module or thinking
# is probably "better", but it's is faster to write longhand than to
# look up the CPAN module, or think out the details. The longhand writing
# won't scale, but since the problem is NP-hard, the problem doesn't
# scale nicely anyway.
#
my %seen;
my $shortest = 999_999_999;   # Shortest distance seen.
my $longest  = -1;            # Longest distance seen.
for (my $i1 = 0; $i1 < @cities; $i1 ++) {
    $seen {$i1} = 1;
    for (my $i2 = 0; $i2 < @cities; $i2 ++) {
        next if $seen {$i2};
        $seen {$i2} = 1;
        for (my $i3 = 0; $i3 < @cities; $i3 ++) {
            next if $seen {$i3};
            $seen {$i3} = 1;
            for (my $i4 = 0; $i4 < @cities; $i4 ++) {
                next if $seen {$i4};
                $seen {$i4} = 1;
                for (my $i5 = 0; $i5 < @cities; $i5 ++) {
                    next if $seen {$i5};
                    $seen {$i5} = 1;
                    for (my $i6 = 0; $i6 < @cities; $i6 ++) {
                        next if $seen {$i6};
                        $seen {$i6} = 1;
                        for (my $i7 = 0; $i7 < @cities; $i7 ++) {
                            next if $seen {$i7};
                            $seen {$i7} = 1;
                            for (my $i8 = 0; $i8 < @cities; $i8 ++) {
                                next if $seen {$i8};
                                $seen {$i8} = 1;

                                my $distance = 
                                   $map {$cities [$i1]} {$cities [$i2]} +
                                   $map {$cities [$i2]} {$cities [$i3]} +
                                   $map {$cities [$i3]} {$cities [$i4]} +
                                   $map {$cities [$i4]} {$cities [$i5]} +
                                   $map {$cities [$i5]} {$cities [$i6]} +
                                   $map {$cities [$i6]} {$cities [$i7]} +
                                   $map {$cities [$i7]} {$cities [$i8]};

                                if ($distance < $shortest) {
                                    $shortest = $distance;
                                }
                                if ($distance > $longest) {
                                    $longest  = $distance;
                                }

                                delete $seen {$i8};
                            }
                            delete $seen {$i7};
                        }
                        delete $seen {$i6};
                    }
                    delete $seen {$i5};
                }
                delete $seen {$i4};
            }
            delete $seen {$i3};
        }
        delete $seen {$i2};
    }
    delete $seen {$i1};
}


say "Solution of part1: $shortest";
say "Solution of part2: $longest";


__END__
