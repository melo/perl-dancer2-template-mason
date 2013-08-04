package    # Hide from PAUSE
  MyTestApp;

use Dancer2;

set template => 'Mason';
set layout   => 'basic';

get '/one' => sub {
  template 'one', { name => 'world' };
};

get '/one_no_layout' => sub {
  template 'one', { name => 'world' }, { layout => undef };
};

get '/one_other_layout' => sub {
  template 'one', { name => 'world' }, { layout => 'other' };
};

true;
