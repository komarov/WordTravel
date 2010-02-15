use MooseX::Declare;


role WordGraph::Model::Uid {
   has Uid => ( is => 'ro', isa => 'Str',  lazy => 1, builder => '_buildUid' );


   #-------------------------------------------------------------------------------
   method _buildUid {
      return rand();
   }


   #-------------------------------------------------------------------------------
   method getUid {
      return $self->Uid;
   }


   #-------------------------------------------------------------------------------
   method isEqual( WordGraph::Model::Uid $Object ) {
      return $self->getUid() eq $Object->getUid();
   }
}
