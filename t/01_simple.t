use strict;
use warnings;
use Test::More tests => 2;
use Data::Deduper;

my @data = (1, 2, 3);

my $dd = Data::Deduper->new(
	expr => sub {
			my ($a, $b) = @_;
			$a eq $b;
		},
	size => 3,
	data => \@data,
);

is($dd->dedup(3,4,5), (4,5))
is($dd->data, (3,4,5))
