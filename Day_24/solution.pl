#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $total = 0;
my @weights;
while (<$fh>) {
    $total += $_;
    push @weights => $_;
}

chomp @weights;

my $nr_of_presents = @weights;

my $set_target1 = $total / 3;
my $set_target2 = $total / 4;

#
# Return all sets of size N matching the target
#
sub find_all_sets;
sub find_all_sets {
    my ($target, $N, @weights) = @_;

    if ($N == 0 && $target == 0) {
        return [];
    }

    return if $N > @weights;
    return if $N <= 0;

    my $sum  = 0;
       $sum += $_ for @weights;
       
    if ($N == @weights && $sum == $target) {
        return [@weights];
    }
    my @results;
    my $try = pop @weights;
    if ($try <= $target) {
        my @sub_results1 = find_all_sets ($target - $try, $N - 1, @weights);
        push @results => map {[$try => @$_]} @sub_results1;
    }
    my @sub_results2 = find_all_sets ($target, $N, @weights);
    push @results => @sub_results2;

    @results;
}

my $QE1 = -1;
MAIN1: foreach my $set_size (1 .. int ($nr_of_presents / 3)) {
    my @sets = find_all_sets $set_target1, $set_size, @weights;
    next unless @sets;

    #
    # Calculate the QE for each set.
    #
    my @qe_sets;
    foreach my $set (@sets) {
        my $qe  = 1;
           $qe *= $_ for @$set;
        push @qe_sets => [$qe => $set];
    }

    #
    # Sort them by QE.
    #
    @qe_sets = sort {$$a [0] <=> $$b [0]} @qe_sets;

    foreach my $qe_set (@qe_sets) {
        my ($qe, $set) = @$qe_set;

        #
        # Now, can we divide the rest into two sets? We only need to know
        # whether there is one. We know if there is a division, each part
        # contains at least as many as our current size, and at most half
        # of the remaining presents.
        #
        my %picked = map {$_ => 1} @$set;
        my @left   = grep {!$picked {$_}} @weights;
        foreach my $set_size2 ($set_size .. int (@left / 2)) {
            my @sub_sets = find_all_sets $set_target1, $set_size2, @left;
            if (@sub_sets) {
                $QE1 = $qe;
                last MAIN1;
            }
        }
    }
}


my $QE2 = -1;
MAIN2: foreach my $set_size1 (1 .. int ($nr_of_presents / 4)) {
    my @sets = find_all_sets $set_target2, $set_size1, @weights;
    next unless @sets;

    #
    # Calculate the QE for each set.
    #
    my @qe_sets;
    foreach my $set (@sets) {
        my $qe  = 1;
           $qe *= $_ for @$set;
        push @qe_sets => [$qe => $set];
    }

    #
    # Sort them by QE.
    #
    @qe_sets = sort {$$a [0] <=> $$b [0]} @qe_sets;

    foreach my $qe_set (@qe_sets) {
        my ($qe, $set) = @$qe_set;

        #
        # Now, can we divide the rest into three sets? We only need to know
        # whether there is one. We know if there is a division, each part
        # contains at least as many as our current size, and at most a third
        # of the remaining presents. We then recurse once again.
        #
        my %picked1 = map {$_ => 1} @$set;
        my @left1   = grep {!$picked1 {$_}} @weights;
        foreach my $set_size2 ($set_size1 .. int (@left1 / 3)) {
            my @sub_sets2 = find_all_sets $set_target2, $set_size2, @left1;
            foreach my $sub_set2 (@sub_sets2) {
                my %picked2 = map {$_ => 1} @$sub_set2;
                my @left2   = grep {!$picked2 {$_}} @left1;
                foreach my $set_size3 ($set_size2 .. int (@left2 / 2)) {
                    my @sub_sets3 = find_all_sets $set_target2,
                                                  $set_size3, @left2;
                    if (@sub_sets3) {
                        $QE2 = $qe;
                        last MAIN2;
                    }
                }
            }
        }
    }
}

my $solution1 = $QE1;
my $solution2 = $QE2;

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
