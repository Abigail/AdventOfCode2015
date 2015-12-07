#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use Digest::MD5 qw [md5_hex];

my $key      = "ckczppom";
my $counter  =  0;
my $filename = "file";

my $sol1;
my $sol2;

while (1) {
    my $input = "${key}${counter}";
    my $hash  = md5_hex $input;
    if ($hash =~ /^0{5}/) {
        $sol1 ||= $counter;
        if ($hash =~ /^0{6}/) {
            $sol2 ||= $counter;
            last;
        }
    }
    $counter ++;
}

say "Solution to part1: $sol1";
say "Solution to part2: $sol2";

__END__
