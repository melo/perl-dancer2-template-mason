#!perl

use strict;
use warnings;
use lib 't/tlib/basic';
use Test::More;
use MyTestApp;
use Dancer2::Test apps => ['MyTestApp'];

is(dancer_response(GET => '/one')->content,              '<my>one world</my>',       'simple template with layout ok');
is(dancer_response(GET => '/one_no_layout')->content,    'one world',                'template, skip layout, ok');
is(dancer_response(GET => '/one_other_layout')->content, '<other>one world</other>', 'template + alt layout, ok');

done_testing();
