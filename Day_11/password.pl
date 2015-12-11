#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

my $password0 = "vzbxkghb";

my $base      = ord 'a';
my $inc_pat   = join "|" => map {chr ($base + $_)     .
                                 chr ($base + $_ + 1) .
                                 chr ($base + $_ + 2)} 0 .. 23;
                                
#
# Letting Perl's magical ++ do the work. This is far from efficient,
# as it could take billions of tries to find a correct one, when the
# next password could also be deduced using smart reasoning. But we'll
# exploit the fact the programming tasks aren't about efficiency.
# For the given input string, this runs in seconds.
#

sub next_password {
    my $password = shift;
    $password ++;
    while ($password =~ /[iol]/        ||
           $password !~ /(.)\1.*(.)\2/ ||
           $password !~ /$inc_pat/) {
        $password ++;
    }
    $password;
}

my $password1 = next_password $password0;
my $password2 = next_password $password1;

say "Solution to part 1: $password1";
say "Solution to part 2: $password2";

__END__
