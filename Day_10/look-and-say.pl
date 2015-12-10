#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

my $start = "1113222113";
my $RUNS1 = 40;
my $RUNS2 = 50;

sub say_str {
    my $in  = shift;
    my $out = "";
    while ($in =~ /\G((.)\2*)/g) {
        my $char   =        $2;
        my $length = length $1;
        $out .= $length . $char;
    }
    $out;
}


my $str = $start;
$str = say_str $str for 1 .. $RUNS1;

say "Solution of part 1: " . length $str;

$str = say_str $str for ($RUNS1 + 1) .. $RUNS2;

say "Solution of part 2: " . length $str;

__END__
