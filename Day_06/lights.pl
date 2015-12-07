#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my    $input = "input";

my    $onoff;
my    $brightness;
push @$onoff      => [(0) x 1000] for 0 .. 999;
push @$brightness => [(0) x 1000] for 0 .. 999;

my $TOGGLE =  2;
my $ON     =  1;
my $OFF    = -1;
my $MAX    =  2;
my $MIN    =  0;

open my $fh, "<", $input;

while (<$fh>) {
    /(?<command>[^0-9]*)
     (?<x1>[0-9]+) \s*,\s*
     (?<y1>[0-9]+) 
     [^0-9]*
     (?<x2>[0-9]+) \s*,\s*
     (?<y2>[0-9]+)/x or die "Failed to parse $_";
    my $command = $+ {command};
    my $x1      = $+ {x1};
    my $y1      = $+ {y1};
    my $x2      = $+ {x2};
    my $y2      = $+ {y2};
    ($x1, $x2) = ($x2, $x1) if $x2 < $x1;
    ($y1, $y2) = ($y2, $y1) if $y2 < $y1;

    my $comm = $command =~ /toggle/ ? $TOGGLE
             : $command =~ /\bon\b/ ? $ON
             :                        $OFF;

    for (my $x = $x1; $x <= $x2; $x ++) {
        for (my $y = $y1; $y <= $y2; $y ++) {
            $$onoff      [$x] [$y]  = $comm == $ON  ? 1
                                    : $comm == $OFF ? 0
                                    :                 1 - $$onoff [$x] [$y];
            $$brightness [$x] [$y] += $comm;
            $$brightness [$x] [$y]  = $MIN if $$brightness [$x] [$y] < $MIN;
        }
    }
}

my $onoff_count = 0;
foreach my $row (@$onoff) {
    $onoff_count += $_ foreach @$row;
}
my $brightness_count = 0;
foreach my $row (@$brightness) {
    $brightness_count += $_ foreach @$row;
}

say "Lights on: $onoff_count";
say "Total brightness: $brightness_count";


__END__
