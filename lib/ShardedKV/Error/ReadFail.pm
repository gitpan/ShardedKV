package ShardedKV::Error::ReadFail;
{
  $ShardedKV::Error::ReadFail::VERSION = '0.18';
}
use Moose;
extends 'ShardedKV::Error';

#ABSTRACT: Thrown when get() fails on a storage backend



has key => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

1;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

=pod

=head1 NAME

ShardedKV::Error::ReadFail - Thrown when get() fails on a storage backend

=head1 VERSION

version 0.18

=head1 DESCRIPTION

ShardedKV::Error::ReadFail is an exception thrown when there is a problem
reading from a particular storage backend. The exception will contain which key
failed.

=head1 PUBLIC ATTRIBUTES

=head2 key

  (is: ro, isa: Str, required)

key holds what particular key was used for the get() call.

=head1 AUTHORS

=over 4

=item *

Steffen Mueller <smueller@cpan.org>

=item *

Nick Perez <nperez@cpan.org>

=item *

Damian Gryski <dgryski@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steffen Mueller.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__


# vim: ts=2 sw=2 et
