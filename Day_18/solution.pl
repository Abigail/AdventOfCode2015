#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $RUNS = 100;

my $input = $ARGV [0] // "input";
open my $fh, "<", $input;

my $solution1 = 0;
my $solution2 = 0;

my @board1;
my @board2;

while (<$fh>) {
    chomp;
    my @row = map {$_ eq "." ? 0 : 
                   $_ eq "#" ? 1 :
                   die "Failed to parse $_\n"} split // => ".$_.";
    push @board1 => [@row];
    push @board2 => [@row];
}
my @border = (0) x @{$board1 [0]};
unshift @board1 => [@border];
push    @board1 => [@border];
unshift @board2 => [@border];
push    @board2 => [@border];

my $X =   @board1;
my $Y = @{$board1 [0]};

$board2 [1]      [1]      = 1;
$board2 [1]      [$Y - 2] = 1;
$board2 [$X - 2] [1]      = 1;
$board2 [$X - 2] [$Y - 2] = 1;


foreach my $run (1 .. $RUNS) {
    my @copy1 = map {[(0) x $Y]} @board1;
    my @copy2 = map {[(0) x $Y]} @board2;
    for (my $x = 1; $x < $X - 1; $x ++) {
        for (my $y = 1; $y < $Y - 1; $y ++) {
            my $neighbours1 = 0;
            my $neighbours2 = 0;
            foreach my $dx (-1, 0, 1) {
                foreach my $dy (-1, 0, 1) {
                    next if $dx == 0 && $dy == 0;
                    $neighbours1 += $board1 [$x + $dx] [$y + $dy];
                    $neighbours2 += $board2 [$x + $dx] [$y + $dy];
                }
            }
            $copy1 [$x] [$y] = $neighbours1 == 3 ||
                               $neighbours1 == 2 && $board1 [$x] [$y] ? 1 : 0;
            $copy2 [$x] [$y] = $neighbours2 == 3 ||
                               $neighbours2 == 2 && $board2 [$x] [$y] ? 1 : 0;
        }
    }
    $copy2 [1]      [1]      = 1;
    $copy2 [1]      [$Y - 2] = 1;
    $copy2 [$X - 2] [1]      = 1;
    $copy2 [$X - 2] [$Y - 2] = 1;
    @board1 = @copy1;
    @board2 = @copy2;
}

for (my $x = 1; $x < $X - 1; $x ++) {
    for (my $y = 1; $y < $Y - 1; $y ++) {
        $solution1 += $board1 [$x] [$y];
        $solution2 += $board2 [$x] [$y];
    }
}

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
