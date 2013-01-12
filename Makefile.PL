
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Never install pure Perl modules again",
  "AUTHOR" => "Nicholas R. Perez <nperez\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "CloudPAN",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "CloudPAN",
  "PREREQ_PM" => {
    "File::Path" => 0,
    "File::Spec" => 0,
    "File::Temp" => 0,
    "HTTP::Tiny" => "0.022",
    "MetaCPAN::API::Tiny" => 0,
    "Symbol" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "1.130120",
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



