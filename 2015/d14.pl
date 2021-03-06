#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper;
use List::Util qw/min max/;
use File::Slurp;
use Algorithm::Combinatorics qw(combinations permutations);

my @f = read_file(\*STDIN);
# @f = map { chomp; int $_ } @f;

my $t = 2503; # duration of race

my $h;
my @herd;
for (@f)
{
    chomp;
    # Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    if (m/(\S+) can fly (\d+) km.s for (\d+) seconds.*for (\d+) sec/)
    {
        $h->{$1}->{speed} = $2;
        $h->{$1}->{duration} = $3;
        $h->{$1}->{rest} = $4;
        push(@herd, $1);
    }
}

my $flying;
my $d;
my $distance;
my $points;
for my $rn (@herd) # init
{
    $flying->{$rn} = 1;
    $d->{$rn} = $h->{$rn}->{duration};
    $distance->{$rn} = 0;
    $points->{$rn} = 0;
}

for my $i (1..$t)
{
    for my $rn (@herd)
    {
        my $r = $h->{$rn};

        if ($flying->{$rn})
        {
            $distance->{$rn} += $r->{speed};
        }

        $d->{$rn}--;

        if ($d->{$rn} == 0)
        {
            $flying->{$rn} = 1 - $flying->{$rn};
            $d->{$rn} = $flying->{$rn} ? $r->{duration} : $r->{rest};
        }
    }

    my $best = max(values %$distance);
    for my $rn (@herd)
    {
        $points->{$rn}++ if $distance->{$rn} == $best;
    }

}

for my $rn (@herd)
{
    printf "%-10s %4d %4d\n", $rn, $distance->{$rn}, $points->{$rn};
}
printf "stage 1: %d\n", max(values %$distance);
printf "stage 2: %d\n", max(values %$points);
