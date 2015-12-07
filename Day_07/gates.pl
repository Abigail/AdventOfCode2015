#!/opt/perl/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';
use autodie;

my $input = "input";
open my $fh, "<", $input;

my %value;
my %command;

my $EQUAL  = 1;
my $OR     = 2;
my $AND    = 3;
my $LSHIFT = 4;
my $RSHIFT = 5;
my $NOT    = 6;

my $MAX    = 65535;

while (<$fh>) {
    chomp;
    my ($command, $target) = split /\s*->\s*/;
    if    ($command =~ /^[0-9]+$/)  {
        $value   {$target} = 0 + $command;
    }
    elsif ($command =~ /^([a-z]+)$/) {
        $command {$target} = [$EQUAL, $1];
    }
    elsif ($command =~ /NOT\s*([0-9]+|[a-z]+)/) {
        $command {$target} = [$NOT, $1];
    }
    elsif ($command =~ /([0-9]+|[a-z]+)\s*(OR|AND|LSHIFT|RSHIFT)
                                       \s*([0-9]+|[a-z]+)/x) {
        my ($in1, $op, $in2) = ($1, $2, $3);
        $command {$target} = [$op eq 'AND'    ? $AND    :
                              $op eq 'OR'     ? $OR     :
                              $op eq 'LSHIFT' ? $LSHIFT :
                              $op eq 'RSHIFT' ? $RSHIFT : die, $in1, $in2];
    }
    else {
        die "Failed to parse $_";
    }
}


sub calculate {
    my %value   = %{$_ [0]};  # Make copies.
    my %command = %{$_ [1]};  
    while (1) {
        foreach my $target (keys %command) {
            my ($command, @inputs) = @{$command {$target}};
            next if grep {/[^0-9]/ && !exists $value {$_}} @inputs;
            my @values = map {/[0-9]/ ? $_ : $value {$_}} @inputs;
            if ($command == $EQUAL) {
                $value {$target} = $values [0];
            }
            elsif ($command == $NOT) {
                $value {$target} = ~$values [0];
            }
            elsif ($command == $OR) {
                $value {$target} = $values [0] | $values [1];
            }
            elsif ($command == $AND) {
                $value {$target} = $values [0] & $values [1];
            }
            elsif ($command == $LSHIFT) {
                $value {$target} = $values [0] << $values [1];
            }
            elsif ($command == $RSHIFT) {
                $value {$target} = $values [0] >> $values [1];
            }
            else {
                die "Unknown command $command";
            }
            $value {$target} &= $MAX;
            delete $command {$target};
        }
        last if exists $value {a} || !keys %command;
    }
    return $value {a};
}

my $sol1 = calculate \%value, \%command;
$value {b} = $sol1;
my $sol2 = calculate \%value, \%command;

printf "Solution of part1: %d\n" => $sol1;
printf "Solution of part2: %d\n" => $sol2;


__END__
