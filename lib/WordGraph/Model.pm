use MooseX::Declare;


class WordGraph::Model {
   use WordGraph::Types;


   has Storage       => ( is => 'ro', isa => 'WordGraph::Model::Storage' );
   has ObjectClasses => ( is => 'ro', isa => 'ArrayRef[Str]', required => 1 );


   #-------------------------------------------------------------------------------
   method BUILD {
      $self->meta->make_mutable;
      foreach my $ObjectClass ( @{ $self->ObjectClasses } ) {
         my $ClassName = 'WordGraph::Model::Object::' . $ObjectClass; 
         eval "use $ClassName;";
         $self->meta->add_method( 
            'get' . $ObjectClass => method( $Uid? ) { 
               $self->_getObject( $ClassName, $Uid ); 
            }
         );
         $self->meta->add_method( 
            'create' . $ObjectClass => sub { 
               my $self = shift;
               my $Object = $ClassName->new( Model => $self, @_ );
               $self->store( $Object );
               return $Object;
            }
         );
      }
      $self->meta->make_immutable;
   }


   #-------------------------------------------------------------------------------
   method _getObject( ClassName $ClassName!, $Uid? ) {
      my $Object;
      if( $Uid ) {
         if( $Object = $self->Storage->lookup( $Uid ) ) {
            return $Object;
         } 
         $Object = $ClassName->new( Model => $self, Uid => $Uid );
      }
      else {
         $Object = $ClassName->new( Model => $self );
         $self->store( $Object );
      }
      return $Object;
   }


   #-------------------------------------------------------------------------------
   method store( WordGraph::Model::Object $Object! ) {
      if( $self->Storage->lookup( $Object->getUid() ) ) {
         return $self->Storage->update( $Object );
      }
      else {
         return $self->Storage->store( $Object->getUid() => $Object );
      }
   }


   #-------------------------------------------------------------------------------
   method delete( WordGraph::Model::Object $Object! ) {
      return $self->Storage->delete( $Object );
   }
}
