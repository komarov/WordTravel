use MooseX::Declare;


class WordGraph::Model::Object with WordGraph::Model::Uid {
   use Moose::Util qw( ensure_all_roles );


   has Model => ( is => 'ro', isa => 'WordGraph::Model', required => 1, weak_ref => 1, traits => [ qw( WordGraph::Model::NotStorable ) ] );


   #-------------------------------------------------------------------------------
   method BUILD {
      foreach my $Attribute ( $self->meta->get_all_attributes() ) {
         if( !$self->_isAttributeStorable( $Attribute ) ) {
            ensure_all_roles( $Attribute, 'KiokuDB::Meta::Attribute::DoNotSerialize' );
         }
      }
   }


   #-------------------------------------------------------------------------------
   method _isAttributeStorable( $Attribute ) {
      return !$Attribute->does( 'WordGraph::Model::NotStorable' );
   }


   #-------------------------------------------------------------------------------
   method update {
      $self->Model->store( $self );
   }


   #-------------------------------------------------------------------------------
   method delete {
      $self->Model->delete( $self );
   }
}
