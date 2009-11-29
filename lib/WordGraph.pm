use MooseX::Declare;
use WordGraph::Types;
use WordGraph::Frame;
use WordGraph::User;


class WordGraph {
   #-------------------------------------------------------------------------------
   method getUser( Maybe[Data::GUID] $Uid? ) {
      if( $Uid ) {
         return WordGraph::User->new( Uid => $Uid );
      }
      else {
         return WordGraph::User->new();
      }
   }


   #-------------------------------------------------------------------------------
   method getFrame( Maybe[Data::GUID] $Uid? ) {
      if( $Uid ) {
         return WordGraph::Frame->new( Uid => $Uid );
      }
      else {
         return WordGraph::Frame->new();
      }
   }
}
