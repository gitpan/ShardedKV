
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "An interface to sharded key-value stores",
  "AUTHOR" => "Steffen Mueller <smueller\@cpan.org>, Nick Perez <nperez\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "ShardedKV",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "ShardedKV",
  "PREREQ_PM" => {
    "Algorithm::ConsistentHash::Ketama" => 0,
    "Array::IntSpan" => 0,
    "Carp" => 0,
    "DBD::mysql" => 0,
    "DBI" => 0,
    "Data::Dumper" => 0,
    "JSON" => 0,
    "JSON::XS" => 0,
    "List::Util" => 0,
    "Moose" => 0,
    "POSIX" => 0,
    "Redis" => 0,
    "Test::More" => "0.88",
    "parent" => 0
  },
  "VERSION" => "0.11",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



