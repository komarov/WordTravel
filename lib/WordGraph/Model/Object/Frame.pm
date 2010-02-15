use MooseX::Declare;


class WordGraph::Model::Object::Frame extends WordGraph::Model::Object {
   use List::Util qw( first );


   has Words         => ( is => 'rw', isa => 'ArrayRef[WordGraph::Model::Object::Word]', default => sub { [] } );
   has Links         => ( is => 'rw', isa => 'ArrayRef[Pair[Str]]', default => sub { [] } );
   has Coordinates   => ( is => 'rw', isa => 'HashRef', default => sub { {} } );


   #-------------------------------------------------------------------------------
   method getWordByUid( $WordUid! ) {
      return first { $_->getUid() eq $WordUid } @{ $self->Words };
   }


   #-------------------------------------------------------------------------------
   method getWords {
      return @{ $self->Words };
   }


   #-------------------------------------------------------------------------------
   method getLinks {
      return @{ $self->Links };
   }


   #-------------------------------------------------------------------------------
   method getLinkedWords( WordGraph::Model::Object::Word $Word! ) {
      my $WordUid = $Word->getUid();
      my @LinkedWords = ();
      foreach my $Link ( @{ $self->Links } ) {
         if( $Link->[ 0 ] eq $WordUid ) {
            push @LinkedWords, $self->getWordByUid( $Link->[ 1 ] );
         }
         elsif( $Link->[ 1 ] eq $WordUid ) {
            push @LinkedWords, $self->getWordByUid( $Link->[ 0 ] );
         }
      }
      return @LinkedWords;
   }


   #-------------------------------------------------------------------------------
   method addWord( WordGraph::Model::Object::Word $Word! ) {
      push @{ $self->Words }, $Word;
      return 1;
   }


   #-------------------------------------------------------------------------------
   method linkWords( WordGraph::Model::Object::Word $WordA!, WordGraph::Model::Object::Word $WordB! ) {
      my $UidsPair = [ map { $_->getUid() } ( $WordA, $WordB )];
      push @{ $self->Links }, $UidsPair;
      return 1;
   }


   #-------------------------------------------------------------------------------
   method setCoordinates( WordGraph::Model::Object::Word $Word!, HashRef $Coordinates ) {
      $self->Coordinates->{ $Word->getUid() } = $Coordinates;
      return 1;
   }

   
   #-------------------------------------------------------------------------------
   method getCoordinates( WordGraph::Model::Object::Word $Word! ) {
      return $self->Coordinates->{ $Word->getUid() };
   }
}
