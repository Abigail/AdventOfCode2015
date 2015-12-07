#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

local $/;          # Slurp mode.
$_ = <>;           # Read entire input.
my $floor = 0;     # Santa starts here.
$floor += y/(/(/;  # Number of floors up.
$floor -= y/)/)/;  # Number of floors down.

say "Final floor: $floor";

__END__
