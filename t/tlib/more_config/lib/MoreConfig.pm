package    # Hide from PAUSE
  MoreConfig;

use Dancer2 ':syntax';

get '/' => sub { template 'index' };

true;
