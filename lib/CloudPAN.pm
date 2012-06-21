package CloudPAN;
{
  $CloudPAN::VERSION = '1.121730';
}

#ABSTRACT: Never install pure Perl modules again

use warnings;
use strict;

BEGIN {
    require MetaCPAN::API::Tiny;
    require Symbol;
    use IO::All;
    my $api = MetaCPAN::API::Tiny->new();

    push(@INC, sub {
        my ($self, $name) = @_;

        my $ret = $api->fetch('module/_search', q => qq|path:lib/$name|, size => 1, fields => 'author,release,path' )
            ->{hits}->{hits}->[0]->{fields} or die "Unable to fetch relevant info from MetaCPAN for $name";

        my $req_url = join('/', $api->{base_url}, 'source', @{$ret}{qw/author release path/});
        
        my $content = $api->{ua}->get($req_url)->{content};
        
        my $io = io('/tmp/' . $name);
        $io->assert;
        $io->mode('>');
        $io->print($content);
        $io->close();

        my @file = split(/(?=\n)/, $content)
            or die "Unable to gather the actual source for $name";
        
        my $reader = sub {
            $_ = shift(@file);
            return scalar(@file) > 0 ? 1 : 0;
        };
        
        return Symbol::gensym(), $reader;
    });
}

1;


=pod

=head1 NAME

CloudPAN - Never install pure Perl modules again

=head1 VERSION

version 1.121730

=head1 SYNOPSIS

    use CloudPAN;
    
    {
        package Foo;
        use Moo;

        has bar => (is => 'rw');
        
        sub baz { $_[0]->bar }
    }
    print Foo->new(bar => 3)->baz . "\n";
    
    # 3

=head1 DESCRIPTION

Ever wanted to load modules from the "cloud"? Love the concept of MetaCPAN and
want to exercise it? Then this module is for you. Simply use this module before
using any other module that doesn't require compilation and you're set. Note
that this doesn't work on all modules (especially ones that mess around with
@INC too). 

=head1 AUTHOR

Nicholas R. Perez <nperez@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Nicholas R. Perez <nperez@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
