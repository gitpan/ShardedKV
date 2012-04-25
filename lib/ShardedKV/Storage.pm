package ShardedKV::Storage;
{
  $ShardedKV::Storage::VERSION = '0.04';
}
use Moose::Role;
# ABSTRACT: Role for classes implementing storage backends


requires qw(get set delete);

no Moose;

1;



=pod

=head1 NAME

ShardedKV::Storage - Role for classes implementing storage backends

=head1 VERSION

version 0.04

=head1 SYNOPSIS

  TODO

=head1 DESCRIPTION

TODO

=role_requires get

TODO

=role_requires set

TODO

=role_requires delete

TODO

=head1 SEE ALSO

=over 4

=item *

L<ShardedKV>

=item *

L<ShardedKV::Storage::Memory>

=item *

L<ShardedKV::Storage::Redis>

=item *

L<ShardedKV::Storage::MySQL>

=back

=head1 AUTHORS

=over 4

=item *

Steffen Mueller <smueller@cpan.org>

=item *

Nick Perez <nperez@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steffen Mueller.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__


