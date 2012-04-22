package ShardedKV::Storage::Redis::String;
{
  $ShardedKV::Storage::Redis::String::VERSION = '0.02';
}
use Moose;
# ABSTRACT: Storing simple string values in Redis
use parent 'ShardedKV::Storage::Redis';
use Encode;
use Redis;

sub get {
  my ($self, $key) = @_;
  # fetch from master by default (TODO revisit later)
  my $master = $self->redis_master;
  my $vref = \($master->get($key));
  Encode::_utf8_on($$vref); # FIXME wrong, wrong, wrong, but Redis.pm would otherwise call encode() all the time
  return $vref;
}

sub set {
  my ($self, $key, $value_ref) = @_;
  my $r = $self->master;
  my $expire = $self->expiration_time;
  my $rv = $r->set($key, $$value_ref);
  $r->expire($key, $expire) if $expire;
  return $rv;
}

no Moose;
__PACKAGE__->meta->make_immutable;



=pod

=head1 NAME

ShardedKV::Storage::Redis::String - Storing simple string values in Redis

=head1 VERSION

version 0.02

=head1 SYNOPSIS

  use ShardedKV;
  use ShardedKV::Storage::Redis::String;
  ... create ShardedKV...
  my $storage = ShardedKV::Storage::Redis::String->new(
    redis_master_str => 'redisshard1:679',
    expiration_time => 60*60, #1h
  );
  ... put storage into ShardedKV...
  
  # values are scalar references to strings
  $skv->set("foo", \"bar");
  my $value_ref = $skv->get("foo");

=head1 DESCRIPTION

This subclass of L<ShardedKV::Storage::Redis> implements
simple string/blob values in Redis. See the documentation
for C<ShardedKV::Storage::Redis> for the interface of this
class.

The values of a C<ShardedKV::Storage::Redis::String> are
actually scalar references to strings.

=head1 SEE ALSO

=over 4

=item *

L<ShardedKV>

=item *

L<ShardedKV::Storage>

=item *

L<ShardedKV::Storage::Redis>

=item *

L<ShardedKV::Storage::Redis::Hash>

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

