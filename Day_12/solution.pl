#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

use JSON;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $solution1 = 0;
my $solution2 = 0;

sub traverse;
sub traverse {
    my $obj = shift;
    my $value1 = 0;  # All.
    my $value2 = 0;  # Excluding red.
    if (ref $obj eq "ARRAY") {
        foreach my $element (@$obj) {
            my ($s1, $s2) = traverse $element;
            $value1 += $s1;
            $value2 += $s2;
        }
    }
    elsif (ref $obj eq "HASH") {
        #
        # Is there red?
        #
        my $has_red = grep {!ref && $_ eq "red"} values %$obj;
        foreach my $element (values %$obj) {
            my ($s1, $s2) = traverse $element;
            $value1 += $s1;
            $value2 += $s2 unless $has_red;
        }
    }
    elsif (!ref $obj) {
        if ($obj =~ /[-+]?[0-9]+/) {
            $value1 += $obj;
            $value2 += $obj;
        }
    }
    else {
        die "Failed to handle ref ", ref $obj;
    }
    ($value1, $value2);
}


while (<$fh>) {
    my $obj = decode_json $_ or die "Failed to decode $_";
    my ($s1, $s2) = traverse $obj;
    $solution1 += $s1;
    $solution2 += $s2;
}

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
