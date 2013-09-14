package    # Hide from PAUSE
  MoreConfig;

use Dancer2;

get '/' => sub { template 'index' };

true;
