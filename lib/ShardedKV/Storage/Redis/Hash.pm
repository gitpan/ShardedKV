package ShardedKV::Storage::Redis::Hash;
{
  $ShardedKV::Storage::Redis::Hash::VERSION = '0.08';
}
use Moose;
# ABSTRACT: Storing hash values in Redis
use parent 'ShardedKV::Storage::Redis';
use Encode;
use Redis;
use Carp ();

sub get {
  my ($self, $key) = @_;
  # fetch from master by default (TODO revisit later)
  my $master = $self->redis_master;
  my %hash = $master->hgetall($key);
  #Encode::_utf8_on($$vref); # FIXME wrong, wrong, wrong, but Redis.pm would otherwise call encode() all the time
  return keys(%hash) ? \%hash : undef;
}

sub set {
  my ($self, $key, $value_ref) = @_;
  if (ref($value_ref) ne 'HASH') {
    Carp::croak("Value must be a hashref");
  }

  my $r = $self->redis_master;
  my $rv = $r->hmset($key, %$value_ref);

  my $expire = $self->expiration_time;
  if (defined $expire) {
    $r->pexpire(
      $key, int(1000*($expire+rand($self->expiration_time_jitter)))
    );
  }

  return $rv;
}

no Moose;
__PACKAGE__->meta->make_immutable;



=pod

=head1 NAME

ShardedKV::Storage::Redis::Hash - Storing hash values in Redis

=head1 VERSION

version 0.08

=head1 SYNOPSIS

  use ShardedKV;
  use ShardedKV::Storage::Redis::Hash;
  ... create ShardedKV...
  my $storage = ShardedKV::Storage::Redis::Hash->new(
    redis_master_str => 'redisshard1:679',
    expiration_time => 60*60, #1h
  );
  ... put storage into ShardedKV...
  
  # values are scalar references to strings
  $skv->set("foo", {bar => 'baz', cat => 'dog'});
  my $value_ref = $skv->get("foo");

=head1 DESCRIPTION

This subclass of L<ShardedKV::Storage::Redis> implements
simple string/blob values in Redis. See the documentation
for C<ShardedKV::Storage::Redis> for the interface of this
class.

The values of a C<ShardedKV::Storage::Redis::Hash> are
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

L<ShardedKV::Storage::Redis::String>

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

