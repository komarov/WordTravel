package WordTravel;
use Dancer;
use Template;
use JSON;

use lib 'lib';
use WordGraph;


my $WordGraph = WordGraph->new();


#-------------------------------------------------------------------------------
before sub {
   var User => $WordGraph->getUser( cookies->{UserUid} );
   set_cookie UserUid => vars->{User}->getUid()->as_string();
};


#-------------------------------------------------------------------------------
get '/' => sub {
   send_file '/index.html';
};


#-------------------------------------------------------------------------------
get '/User/:Uid' => sub {
   set_cookie UserUid => params->{Uid};
   redirect '/';
};


#-------------------------------------------------------------------------------
get '/Frame/:Uid' => sub {
   content_type 'application/json';
   my $FrameUid = params->{Uid};
   my $RenderedFrame = vars->{User}->renderFrame( $WordGraph->getFrame( $FrameUid ) );
   return to_json( $RenderedFrame );
};


#-------------------------------------------------------------------------------
get '/Frame/List' => sub {
   content_type 'application/json';
   my $FrameList = vars->{User}->getFrameList();
   return to_json( $FrameList );
};


true;
