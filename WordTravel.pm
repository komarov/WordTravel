package WordTravel;
use Dancer;
use Template;
use JSON;

use lib 'lib';
use WordGraph;


my $WordGraph = WordGraph->new();

#-------------------------------------------------------------------------------
before sub {
   var User => $WordGraph->getUser( cookies->{UserUid}->{value} );
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
get '/Frame/List' => sub {
   content_type 'application/json';
   my $FrameList = vars->{User}->getFrameList();
   return to_json( $FrameList );
};


#-------------------------------------------------------------------------------
get '/Frame/:Uid' => sub {
   my $FrameUid = params->{Uid};
   if( my $Frame = $WordGraph->getFrame( $FrameUid ) ) {
      content_type 'application/json';
      my $RenderedFrame = vars->{User}->renderFrame( $Frame );
      return to_json( $RenderedFrame );
   }
   else {
      redirect '/';
   }
};


#-------------------------------------------------------------------------------
post '/Frame/:Uid/Guess' => sub {
   my $FrameUid = params->{Uid};
   if( my $Frame = $WordGraph->getFrame( $FrameUid ) ) {
      my $Guess = params->{Guess};
      return vars->{User}->guessWordInFrame( Frame => $Frame, Guess => $Guess );
   }
   else {
      return;
   }
};

true;
