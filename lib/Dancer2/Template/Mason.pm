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

  $mason_config{comp_root} = $config->{comp_root} || $self->views;
  $mason_config{data_dir} = $config->{data_dir} if exists $config->{data_dir};

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
