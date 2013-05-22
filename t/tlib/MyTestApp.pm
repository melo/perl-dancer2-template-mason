package    # Hide from PAUSE
  MyTestApp;

use Dancer2;

set template => 'Mason';
set layout   => undef;

get '/one' => sub {
  template 'one', { name => 'world' };
};

true;
