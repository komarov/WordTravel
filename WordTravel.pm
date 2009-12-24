package WordTravel;
use Dancer;
use Template;

use lib 'lib';
use WordGraph;

get '/' => sub {
   send_file '/index.html';
};

get '/login/:Uid' => sub {
   set_cookie UserUid => params->{Uid};
   redirect '/';
};

true;
