use MooseX::Declare;
use WordGraph::Types;


role WordGraph::Uid {
   use Data::GUID;


   has Uid => ( is => 'ro', isa => 'Data::GUID', coerce => 1, lazy => 1, builder => '_buildUid' );


   #-------------------------------------------------------------------------------
   method _buildUid {
      return Data::GUID->new();
   }


   #-------------------------------------------------------------------------------
   method getUid {
      return $self->Uid;
   }


   #-------------------------------------------------------------------------------
   method isEqual( WordGraph::Uid $Object ) {
      if( ( $self->getUid() <=> $Object->getUid() ) == 0 ) {
         return 1;
      }
      else {
         return 0;
      }
   }
}
