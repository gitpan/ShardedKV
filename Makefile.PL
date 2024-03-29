
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.013.
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "An interface to sharded key-value stores",
  "AUTHOR" => "Steffen Mueller <smueller\@cpan.org>, Nick Perez <nperez\@cpan.org>, Damian Gryski <dgryski\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "ShardedKV",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "ShardedKV",
  "PREREQ_PM" => {
    "Algorithm::ConsistentHash::Ketama" => "0.00008",
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
    "Throwable" => 0,
    "parent" => 0
  },
  "TEST_REQUIRES" => {},
  "VERSION" => "0.20",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Algorithm::ConsistentHash::Ketama" => "0.00008",
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
  "Throwable" => 0,
  "parent" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



