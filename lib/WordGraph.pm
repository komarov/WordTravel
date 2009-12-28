use MooseX::Declare;
use WordGraph::Types;
use WordGraph::Frame;
use WordGraph::User;


class WordGraph {
   #-------------------------------------------------------------------------------
   method getUser( $Uid? ) {
      if( $Uid ) {
         return WordGraph::User->new( Uid => $Uid );
      }
      else {
         return WordGraph::User->new();
      }
   }


   #-------------------------------------------------------------------------------
   method getFrame( $Uid? ) {
      if( $Uid ) {
         return WordGraph::Frame->new( Uid => $Uid );
      }
      else {
         return WordGraph::Frame->new();
      }
   }
}
