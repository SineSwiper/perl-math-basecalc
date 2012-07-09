#! perl

use strict;
use warnings;
use Test::More tests => (6 * 44) + 1;
use Math::BigFloat;
my $class = 'Math::BaseCalc';
use_ok($class);

my @calcs;
push(@calcs, new_ok( $class => [ digits=>[ '0', '&' ] ]) );
push(@calcs, new_ok( $class => [ digits=>[ '0', '-' ] ]) );
push(@calcs, new_ok( $class => [ digits=>[ '0', '.' ] ]) );
push(@calcs, new_ok( $class => [ digits=>[ '0', '&' ], neg_char => '~', radix_char => ',' ]) );
push(@calcs, new_ok( $class => [ digits=>[ '0', '-' ], neg_char => '~', radix_char => ',' ]) );
push(@calcs, new_ok( $class => [ digits=>[ '0', '.' ], neg_char => '~', radix_char => ',' ]) );

my $bignum = Math::BigFloat->new('999999999999999999999999');

for my $calcX ( @calcs ) {
  for my $s ($bignum->bneg(), -20..20, $bignum) {
    my $source = $s / 2;
    my $in_base_X  = $calcX->to_base( $source );
    my $in_base_10 = $calcX->from_base( $in_base_X );

    # expected result may have changed based on lack of neg/radix
    my $expect = $source;
    $expect = abs($expect) unless ($calcX->{neg_char});
    $expect = int($expect) unless ($calcX->{radix_char});

    # fix unnecessary zeros
    $expect =~ s/0+$// if ($expect =~ /\./);
    $expect =~ s/\.$//;  # float to whole number

    is $in_base_10, $expect, "from( to ( $source ) == $in_base_X ) --> $expect (using ".join(',', $calcX->digits).")";
  }
}
