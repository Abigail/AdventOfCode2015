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

my @instructions;
while (<$fh>) {
    chomp;
    /^(?<command>\S+)\s+(?:(?<register>[ab]),?\s*)?(?<jump>[-+][0-9]+)?$/
        or die "Cannot parse '$_'";
    my $command  = $+ {command};
    my $register = $+ {register};
    my $jump     = $+ {jump};
    if ($command eq "inc" ||
        $command eq "tpl" ||
        $command eq "hlf") {
        die "No register for command: '$_'\n" unless defined $register;
        push @instructions => [$command => $register];
    }
    elsif ($command eq "jmp") {
        die "No distance for command: '$_'\n" unless defined $jump;
        push @instructions => [$command => $jump]; 
    }
    elsif ($command eq "jio" ||
           $command eq "jie") {
        die "No register or no distance for command: '$_'\n"
                               unless defined $jump &&
                                      defined $register;
        push @instructions => [$command => $register, $jump];
    }
    else {
        die "Failed to lex '$_'\n";
    }
}



sub run_program {
    my ($ra, $rb) = @_;
    my %register = (
        a => $ra,
        b => $rb,
    );
    my $pc = 0;
    while (1) {
        my $instruction = $instructions [$pc];
        last unless defined $instruction;
        my $command = $$instruction [0];
        if ($command eq "inc") {
            $register {$$instruction [1]} ++;
            $pc ++;
            next;
        }
        elsif ($command eq "tpl") {
            $register {$$instruction [1]} *= 3;
            $pc ++;
        }
        elsif ($command eq "hlf") {
            $register {$$instruction [1]} =
                   int ($register {$$instruction [1]} / 2);
            $pc ++;
        }
        elsif ($command eq "jmp") {
            $pc += $$instruction [1];
        }
        elsif ($command eq "jie") {
            if ($register {$$instruction [1]} % 2 == 0) {
                $pc += $$instruction [2];
            }
            else {
                $pc ++;
            }
        }
        elsif ($command eq "jio") {
            if ($register {$$instruction [1]} == 1) {
                $pc += $$instruction [2];
            }
            else {
                $pc ++;
            }
        }
        else {
            die "Encountered unknown instruction $command\n";
        }
    }
    return $register {b};
}

$solution1 = run_program (0, 0);
$solution2 = run_program (1, 0);

say "Solution of part1: $solution1";
say "Solution of part2: $solution2";

close $fh;

__END__
