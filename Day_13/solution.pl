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

my $happiness;

sub permutations;
sub permutations {
    my @elements = @_;
    return unless @elements;
    return [@elements] if @elements == 1;
    my @result;
    for (my $i = 0; $i < @elements; $i ++) {
        my $person = $elements [$i];
        my @others = @elements [grep {$_ != $i} 0 .. $#elements];
        my @perms  = permutations @others;
        push @result => [$person => @$_] foreach @perms;
    }
    @result;
}

sub find_most_happiness {
    my $happiness = shift;
    my @people = keys %$happiness;
    my @perms = permutations @people;

    my $most_happiness = 0;

    foreach my $permutation (@perms) {
        my $this_happiness = 0;
        for (my $i = 0; $i < @$permutation; $i ++) {
            my $person1 = $$permutation [ $i];
            my $person2 = $$permutation [($i + 1) % @$permutation];
            $this_happiness += ($$happiness {$person1} {$person2} // 0) +
                               ($$happiness {$person2} {$person1} // 0);
        }
        $most_happiness = $this_happiness if $this_happiness > $most_happiness;
    }
    $most_happiness;
}

while (<$fh>) {
    /^(\S+) \s+ would \s+ (lose|gain) \s+ ([0-9]+) \s+ .* \s+ (\S+)\./x
       or die "Failed to parse $_";
    my ($p1, $lose_gain, $amount, $p2) = ($1, $2, $3, $4);
    $amount = - $amount if $lose_gain eq "lose";
    $$happiness {$p1} {$p2} = $amount;
}

$solution1 = find_most_happiness $happiness;

my @people = keys %$happiness;
$$happiness {$_} {ME} = $$happiness {ME} {$_} = 0 for @people;

$solution2 = find_most_happiness $happiness;

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
