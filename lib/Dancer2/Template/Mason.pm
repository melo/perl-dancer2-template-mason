package Dancer2::Template::Mason;

# ABSTRACT: Mason template engine for Dancer2
# VERSION
# AUTHORITY

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

=encoding utf8

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

Using it, your app views and layouts can be written using the Mason templating
system.

Please note the following caveats:

=over 4

=item Extension support in Dancer2 is disabled

This module ignore all the extension logic that
L<Dancer2::Core::Role::Template> does. L<Mason> already takes care of managing
extensions for you.

=back


=head1 METHODS

=over

=item render($template, $tokens)

Renders a template using the L<Mason> engine.

=back


=head1 SEE ALSO

L<Dancer2>, L<Mason>

=cut
