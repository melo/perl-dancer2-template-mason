package Dancer2::Template::Mason;

# ABSTRACT: Mason template engine for Dancer2
our $VERSION = '0.001'; # VERSION
our $AUTHORITY = 'cpan:MELO'; # AUTHORITY

use utf8;
use Moo;
use Dancer2::Core::Types;
use File::Temp;
use Mason;

with "Dancer2::Core::Role::Template";

has "+engine" => (isa => InstanceOf ["Mason::Interp"]);

has "root_dir" => (is => 'rwp');

sub _template_name { return $_[1] }    ## Skip extension processing in Mason

sub _build_engine {
  my ($self) = @_;
  my $config = $self->config || {};

  my %mason_config;
  for my $cfg (keys %$config) {
    next if $cfg eq 'environment' or $cfg eq 'location';
    $mason_config{$cfg} = $config->{$cfg};
  }
  $mason_config{comp_root} = $self->views unless $mason_config{comp_root};

  $self->_set_root_dir($mason_config{comp_root});

  return Mason->new(%mason_config);
}

sub render {
  my ($self, $tmpl, $tokens) = @_;
  my $engine   = $self->engine;
  my $root_dir = $self->root_dir;

  $tmpl =~ s/^\Q$root_dir//;    # cut the leading path, Mason does this for us

  my $content = $engine->run($tmpl, %$tokens)->output;
  return $content;
}

1;

__END__

=pod

=encoding utf-8

=for :stopwords Pedro Melo ACKNOWLEDGEMENTS cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 NAME

Dancer2::Template::Mason - Mason template engine for Dancer2

=head1 VERSION

version 0.001

=head1 SYNOPSIS

C<config.yaml>:

    template: Mason

    ## optionally
    layout: basic

    engines:
      template:
        Mason:
          ## Mason::Interp options

A Dancer 2 application:

    use Dancer2;

    get /page/:number => sub {
        my $page_num = params->{number};
        template "foo", { page_num => $page_num };
    };

=head1 DESCRIPTION

This module provides the glue between L<Dancer2> and L<Mason>.

Using it, your app views and layouts can be written using the Mason
templating system.

Please note the following caveats:

=over 4

=item Extension support in Dancer2 is disabled

This module ignore all the extension logic that
L<Dancer2::Core::Role::Template> does. L<Mason> already takes care of
managing extensions for you.

=back

=encoding utf8

=head1 METHODS

=over

=item render($template, $tokens)

Renders a template using the L<Mason> engine.

=head1 SEE ALSO

L<Dancer2>, L<Mason>

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc Dancer2::Template::Mason

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<http://metacpan.org/release/Dancer2-Template-Mason>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/D/Dancer2-Template-Mason>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=Dancer2-Template-Mason>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=Dancer2::Template::Mason>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/Dancer2-Template-Mason>

=back

=head2 Email

You can email the author of this module at C<MELO at cpan.org> asking for help with any problems you have.

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the web interface at L<https://github.com/melo/perl-dancer2-template-mason/issues>. You will be automatically notified of any progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/melo/perl-dancer2-template-mason>

  git clone git://github.com/melo/perl-dancer2-template-mason.git

=head1 AUTHOR

Pedro Melo <melo@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Pedro Melo.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
