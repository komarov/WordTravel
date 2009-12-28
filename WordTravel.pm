package WordTravel;
use Dancer;
use Template;
use JSON;

use lib 'lib';
use WordGraph;


my $WordGraph = WordGraph->new();


#-------------------------------------------------------------------------------
before sub {
   var User => $WordGraph->getUser( 'BB2589D8-F26D-11DE-B903-4E49BECC9A9F' );
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
   my $FrameUid = params->{Uid};
   if( my $Frame = $WordGraph->getFrame( $FrameUid ) ) {
      content_type 'application/json';
      my $RenderedFrame = vars->{User}->renderFrame();
      return to_json( $RenderedFrame );
   }
   else {
      redirect '/';
   }
};


#-------------------------------------------------------------------------------
get '/Frame/List' => sub {
   content_type 'application/json';
   my $FrameList = vars->{User}->getFrameList();
   return to_json( $FrameList );
};


#-------------------------------------------------------------------------------
post '/Frame/:Uid/Guess' => sub {
   content_type 'application/json';
   my $FrameUid = params->{Uid};
   if( my $Frame = $WordGraph->getFrame( $FrameUid ) ) {
      my $Guess = cgi->param( 'Guess' );
      return $Guess;
      return to_json( vars->{User}->guessWordInFrame( Frame => $Frame, Guess => $Guess ) );
   }
   else {
      return;
   }
};

true;
