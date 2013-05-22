#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More;
use MyTestApp;
use Dancer2::Test apps => ['MyTestApp'];

is(dancer_response(GET => '/one')->content, 'one world');

done_testing();
