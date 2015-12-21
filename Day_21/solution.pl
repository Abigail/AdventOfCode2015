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

my ($boss_hp, $boss_damage, $boss_ac);
while (<$fh>) {
    chomp;
    my ($what, $amount) = split /:\s*/;
    if    ($what =~ /^Hit/)    {$boss_hp     = $amount}
    elsif ($what =~ /^Damage/) {$boss_damage = $amount}
    elsif ($what =~ /^Armor/)  {$boss_ac     = $amount}
    else {
        die "Failed to parse $_\n";
    }
}

# Cost, +dam, +AX
my @weapons = (
    [  8,   4,   0],
    [ 10,   5,   0],
    [ 25,   6,   0],
    [ 40,   7,   0],
    [ 74,   8,   0],
);
my @armour = (
    [  0,   0,   0],
    [ 13,   0,   1],
    [ 31,   0,   2],
    [ 53,   0,   3],
    [ 75,   0,   4],
    [102,   0,   5],
);
my @rings = (
    [  0,   0,   0],
    [  0,   0,   0],
    [ 25,   1,   0],
    [ 50,   2,   0],
    [100,   3,   0],
    [ 20,   0,   1],
    [ 40,   0,   2],
    [ 80,   0,   3],
);

my $best  = 999_999_999;
my $worst = 0;
my $my_hp = 100;
foreach my $weapon (@weapons) {
    foreach my $armour (@armour) {
        for (my $r1 = 0; $r1 < @rings; $r1 ++) {
            my $ring1 = $rings [$r1];
            for (my $r2 = $r1 + 1; $r2 < @rings; $r2 ++) {
                my $ring2 = $rings [$r2];
                my @equipment = ($weapon, $armour, $ring1, $ring2);
                my ($cost, $my_damage, $my_ac) = (0, 0, 0);
                $cost      += $$_ [0] foreach @equipment;
                $my_damage += $$_ [1] foreach @equipment;
                $my_ac     += $$_ [2] foreach @equipment;

                #
                # Calculate how many rounds the boss needs.
                #
                my $boss_damage_per_round = $boss_damage - $my_ac;
                   $boss_damage_per_round = 1 if $boss_damage_per_round <= 0;

                #
                # Number of rounds boss needs
                #
                my $boss_rounds = int ($my_hp / $boss_damage_per_round);
                   $boss_rounds ++ if  $my_hp % $boss_damage_per_round;

                #
                # Rounds I need
                #
                my $my_damage_per_round = $my_damage - $boss_ac;
                   $my_damage_per_round = 1 if $my_damage_per_round <= 0;

                #
                # Number of rounds I need
                #
                my $my_rounds = int ($boss_hp / $my_damage_per_round);
                   $my_rounds ++ if  $boss_hp % $my_damage_per_round;

                if ($my_rounds <= $boss_rounds) {
                    #
                    # I win
                    #
                    $best  = $cost if $cost < $best;
                }
                else {
                    #
                    # Boss wins
                    #
                    $worst = $cost if $cost > $worst;
                }
            }
        }
    }
}

$solution1 = $best;
$solution2 = $worst;

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
