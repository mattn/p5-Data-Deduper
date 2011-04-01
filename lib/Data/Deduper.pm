package Data::Deduper;
use strict;
use warnings;
use YAML;

sub new {
    my $class = shift;
    my %args = ( @_ == 1 ? %{ $_[0] } : @_ );
    bless {
        data => \@{ $args{data} } || {},
        expr => $args{expr} || sub { my ( $a, $b ) = @_; $a eq $b },
        size => $args{size} || 10,
      },
      __PACKAGE__;
}

sub init {
    my $self = shift;
    my @ret = ( @_ == 1 ? @{ $_[0] } : @_ );
    my $count = @ret;
    my $size  = $self->{size};
    @ret = @ret[ ( $count - $size ) .. $count - 1 ] if $count > $size;
    @{ $self->{data} = \@ret };
}

sub dedup {
    my $self = shift;
    my @data = ( @_ == 1 ? @{ $_[0] } : @_ );
    my @ret  = @{ $self->{data} };
    for my $a (@data) {
        unless ( grep { $self->{expr}( $_, $a ) } @ret ) {
            push @ret, $a;
        }
    }
    my $count = @ret;
    my $size  = $self->{size};
    @ret = @ret[ ( $count - $size ) .. $count - 1 ] if $count > $size;
    @{ $self->{data} = \@ret };
}

1;
__END__

=head1 NAME

Data::Deduper - remove duplicated item from array

=head1 SYNOPSIS

    use Data::Deduper;
    my @data = (1, 2, 3);
    my $dd = Data::Deduper->new(
        expr => sub { my ($a, $b) = @_; $a eq $b },
        size => 3,
        data => \@data,
    );

=head1 DESCRIPTION

Data::Deduper removes duplicaetd items in array. This is useful for fetching RSS/Atom feed continual.

=head1 INTERFACE

=head2 C<< Data::Deduper->new( expr => $expr, size => $size, data => $data ) >>

Creates a deduper instance.
$expr is specified as expr of grep. $size mean max size of array. $data is
initial array.

=head2 C<< $deduper->init( @data ) >>

reset items. 

=head2 C<< $deduper->deup( @data ) >>

dedup items. each item in @data will be checked whether is duplicate item. 

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<XML::Feed::Deduper>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
