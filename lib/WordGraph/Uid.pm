use MooseX::Declare;
use WordGraph::Types;


role WordGraph::Uid {
   use Data::GUID;


   has Uid => ( is => 'ro', isa => 'Data::GUID', coerce => 1, lazy => 1, builder => '_buildUid' );


   #-------------------------------------------------------------------------------
   method _buildUid {
      return Data::GUID->new();
   }
}
