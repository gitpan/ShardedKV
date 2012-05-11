package ShardedKV::Storage::Redis;
{
  $ShardedKV::Storage::Redis::VERSION = '0.11';
}
use Moose;
# ABSTRACT: Abstract base class for storing k/v pairs in Redis

use Encode;
use Redis;
use List::Util qw(shuffle);

with 'ShardedKV::Storage';


has 'redis_master_str' => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);


# For either failover or reading => TODO might make sense to separate the two
has 'redis_slave_strs' => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  required => 1,
  default => sub {[]},
);


has 'redis_master' => (
  is => 'rw',
  isa => 'Redis',
  lazy => 1,
  builder => '_make_master_conn',
);


has 'expiration_time' => ( # in seconds
  is => 'rw',
  #isa => 'Num',
);


has 'expiration_time_jitter' => ( # in seconds
  is => 'rw',
  #isa => 'Num',
  default => 0,
);



has 'database_number' => (
  is => 'rw',
  # isa => 'Int',
  trigger => sub {
    my $self = shift;
    $self->{database_number} = shift;
    if (defined $self->{redis_master}) {
      $self->redis_master->select($self->{database_number});
    }
  },
);

sub _make_connection {
  my ($self, $endpoint) = @_;
  my $r = Redis->new( # dies if it can't connect!
    server => $endpoint,
    encoding => undef, # no automatic utf8 encoding for performance
  );
  my $dbno = $self->database_number;
  $r->select($dbno) if defined $dbno;
  return $r;
}

sub _make_master_conn {
  my $self = shift;
  return $self->_make_connection($self->redis_master_str);
}

sub _make_slave_conn {
  my $self = shift;
  my $conn;
  foreach my $slave (shuffle(@{$self->redis_slave_strs})) {
    last if eval {
      $conn = $self->_make_connection($slave);
    };
  }
  die if not $conn;
  return $conn;
}


sub delete {
  my ($self, $key) = @_;
  return $self->redis_master->del($key);
}


sub get { die "Method get() not implemented in abstract base class" }


sub set { die "Method set() not implemented in abstract base class" }

no Moose;
__PACKAGE__->meta->make_immutable;



=pod

=head1 NAME

ShardedKV::Storage::Redis - Abstract base class for storing k/v pairs in Redis

=head1 VERSION

version 0.11

=head1 SYNOPSIS

  # use a subclass instead

=head1 DESCRIPTION

This class consumes the L<ShardedKV::Storage> role. It is an abstract base
class for storing key-value pairs in Redis. It does not actually implement
the C<get()> and C<set()> methods and does not impose a Redis value type.
Different subclasses of this class are expected to represent different
storages for distinct Redis value types.

=head1 PUBLIC ATTRIBUTES

=head2 redis_master_str

A hostname:port string pointing at the Redis master for this shard.
Required.

=head2 redis_slave_strs

Array reference of hostname:port strings representing Redis slaves
of the master. Currently unused, will eventually be used for either
reading or master failover.

=head2 redis_master

The C<Redis> object that represents the master connection. Will be
generated from the C<redis_master_str> attribute and may be reset/reconnected
at any time.

=head2 expiration_time

Base key expiration time to use in seconds.
Defaults to undef / not expiring at all.

=head2 expiration_time_jitter

Additional random jitter to add to the expiration time.
Defaults to 0. Don't set to undef to disable, set to 0
to disable.

=head2 database_number

Indicates the number of the Redis database to use for this shard.
If undef/non-existant, no specific database will be selected,
so the Redis server will use the default.

=head1 PUBLIC METHODS

=head2 delete

Implemented in the base class, this method deletes the given key from the Redis shard.

=head2 get

Not implemented in the base class. This method is supposed to fetch a value
back from Redis. Beware: Depending on the C<ShardedKV::Storage::Redis> subclass,
the reference type that this method returns may vary. For example, if you use
C<ShardedKV::Storage::Redis::String>, the return value will be a scalar reference
to a string. For C<ShardedKV::String::Redis::Hash>, the return value is
unsurprisingly a hash reference.

=head2 set

The counterpart to C<get>. Expects values as second argument. The value must
be of the same reference type that is returned by C<get()>.

=head1 SEE ALSO

=over 4

=item *

L<ShardedKV>

=item *

L<ShardedKV::Storage>

=item *

L<ShardedKV::Storage::Redis::String>

=item *

L<ShardedKV::Storage::Redis::Hash>

=item *

L<Redis>

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

