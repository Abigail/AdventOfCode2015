#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $boss_hp;
my $boss_dam;

while (<$fh>) {
    chomp;
    my ($type, $amount) = split /:\s+/;
    if ($type =~ /^H/) {
        $boss_hp = $amount;
    }
    elsif ($type =~ /^D/) {
        $boss_dam = $amount;
    }
    else {
        die "Failed to parse: $_\n";
    }
}

my @spells = (
    # -Mana,  Turns,   Dam,  +HP, +AC, +Mana],
    [    53,      0,     4,    0,   0,     0],   # Magic Missile
    [    73,      0,     2,    2,   0,     0],   # Drain
    [   113,      6,     0,    0,   7,     0],   # Shield
    [   173,      6,     3,    0,   0,     0],   # Poison
    [   229,      5,     0,    0,   0,   101],   # Recharge
);
my $MM_MANA      =  53;
my $MM_DAM       =   4;
my $DR_MANA      =  73;
my $DR_DAM       =   2;
my $DR_HEAL      =   2;
my $SH_MANA      = 113;
my $SH_AC        =   7;
my $SH_TURNS     =   6;
my $PO_MANA      = 173;
my $PO_DAM       =   3;
my $PO_TURNS     =   6;
my $RE_MANA      = 229;
my $RE_TURNS     =   5;
my $RE_PLUS_MANA = 101;

my $MY_HP      = 0;
my $MY_MANA    = 1;
my $BOSS_HP    = 2;
my $SHIELD     = 3;  # Turn counter
my $POISON     = 4;  # Turn counter
my $RECHARGE   = 5;  # Turn counter
my $MANA_SPEND = 6;
my $HARD       = 7;



sub run_effects {
    my ($state, $players_turn) = @_;

    if ($players_turn && $$state [$HARD]) {
        $$state [$MY_HP] --;
    }

    return if $$state [$BOSS_HP] <= 0 ||
              $$state [$MY_HP]   <= 0;
    #
    # Do any effects -- in situ
    #
    if ($$state [$POISON]) {
        #
        # Boss gets damage
        #
        $$state [$BOSS_HP] -= $PO_DAM;
        $$state [$POISON] --;
    }
    if ($$state [$RECHARGE]) {
        $$state [$MY_MANA] += $RE_PLUS_MANA;
        $$state [$RECHARGE] --;
    }
    if ($$state [$SHIELD]) {
        $$state [$SHIELD] --;
    }
}

sub run_game {
    my $game  = shift;
    my @games = ($game);
    my %seen;
    while (1) {
        die "No solution?\n" unless @games;
        my $state = shift @games;

        run_effects $state, 1;
        next if $$state [$MY_HP] <= 0;  # We died.
        if ($$state [$BOSS_HP] <= 0) {
            return $$state [$MANA_SPEND];
        }

        my @new_states;

        #
        # Now we have five spells we may be able to cast. 
        # Cast them in order of mana spend; each time creating
        # a new state.
        #
        if ($$state [$MY_MANA] >= $MM_MANA) {
            my $state = [@$state];   # Copy
            $$state [$MY_MANA]    -= $MM_MANA;
            $$state [$MANA_SPEND] += $MM_MANA;
            $$state [$BOSS_HP]    -= $MM_DAM;
            return $$state [$MANA_SPEND] if $$state [$BOSS_HP] <= 0;
            push @new_states => $state;
        }
        if ($$state [$MY_MANA] >= $DR_MANA) {
            my $state = [@$state];   # Copy
            $$state [$MY_MANA]    -= $DR_MANA;
            $$state [$MANA_SPEND] += $DR_MANA;
            $$state [$BOSS_HP]    -= $DR_DAM;
            $$state [$MY_HP]      += $DR_HEAL;
            return $$state [$MANA_SPEND] if $$state [$BOSS_HP] <= 0;
            push @new_states => $state;
        }
        if ($$state [$MY_MANA] >= $SH_MANA && !$$state [$SHIELD]) {
            my $state = [@$state];   # Copy
            $$state [$MY_MANA]    -= $SH_MANA;
            $$state [$MANA_SPEND] += $SH_MANA;
            $$state [$SHIELD]      = $SH_TURNS;
            push @new_states => $state;
        }
        if ($$state [$MY_MANA] >= $PO_MANA && !$$state [$POISON]) {
            my $state = [@$state];   # Copy
            $$state [$MY_MANA]    -= $PO_MANA;
            $$state [$MANA_SPEND] += $PO_MANA;
            $$state [$POISON]      = $PO_TURNS;
            push @new_states => $state;
        }
        if ($$state [$MY_MANA] >= $RE_MANA && !$$state [$RECHARGE]) {
            my $state = [@$state];   # Copy
            $$state [$MY_MANA]    -= $RE_MANA;
            $$state [$MANA_SPEND] += $RE_MANA;
            $$state [$RECHARGE]    = $RE_TURNS;
            push @new_states => $state;
        }

        #
        # Now it's the boss' turn. Try each new state
        #
        foreach my $state (@new_states) {
            #
            # First, run the effects. Boss may die here.
            #
            run_effects $state, 0;
            if ($$state [$BOSS_HP] <= 0) {
                return $$state [$MANA_SPEND];
            }
            #
            # Now, the boss hits.
            #
            my $damage = $boss_dam - ($$state [$SHIELD] ? $SH_AC : 0);
               $damage = 1 if $damage < 1;

            $$state [$MY_HP] -= $damage;
        }

        #
        # Filter out the cases were we died.
        #
        @new_states = grep {$$_ [$MY_HP] > 0} @new_states;

        #
        # Filter out states we've seen
        #
        @new_states = grep {!$seen {$$_ [$MY_HP],
                                    $$_ [$MY_MANA],
                                    $$_ [$BOSS_HP],
                                    $$_ [$SHIELD],
                                    $$_ [$POISON],
                                    $$_ [$RECHARGE]} ++} @new_states;

        if (@new_states) {
            push @games => @new_states;
            @games = sort {$$a [$MANA_SPEND] <=> $$b [$MANA_SPEND]} @games;
        }
    }
}

my $START_HP   =  50;
my $START_MANA = 500;

my $solution1  = run_game [$START_HP, $START_MANA, $boss_hp, 0, 0, 0, 0, 0];
my $solution2  = run_game [$START_HP, $START_MANA, $boss_hp, 0, 0, 0, 0, 1];

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
