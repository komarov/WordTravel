use MooseX::Declare;
use MooseX::Types;
use Data::GUID;


class WordGraph::Object {
   has Uid  => ( is => 'ro', isa => 'Data::GUID', coerce => 1, lazy => 1, builder => '_buildUid' );


   #-------------------------------------------------------------------------------
   method _buildUid {
      return Data::GUID->new();
   }
}
