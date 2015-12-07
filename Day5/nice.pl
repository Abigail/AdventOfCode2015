#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

my $nice = 0;
while (<>) {
    $nice ++ if /[aeiou].*[aeiou].*[aeiou]/ &&
                /(.)\1/                     &&
               !/ab|cd|pq|xy/;
}

say "Got $nice nice strings";

__END__
