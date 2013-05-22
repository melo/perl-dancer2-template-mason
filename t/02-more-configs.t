#!perl

use strict;
use warnings;
use lib 't/tlib/more_config/lib';
use Test::More;
use MoreConfig;
use Dancer2::Test apps => ['MoreConfig'];

TODO: {
  local $TODO = "Still figuring out how to test this with Dancer2::Test";
  is(
    dancer_response(GET => '/', { params => { name => 'Melga' } })->content,
    '<p>start your Dance, Melga!</p>',
    'no funny chars ok'
  );
  is(
    dancer_response(GET => '/', { params => { name => '<Melga>' } })->content,
    '<p>start your Dance, &lt;Melga&gt;!</p>',
    'proper HTML escapes ok'
  );
}

done_testing();
