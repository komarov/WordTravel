use MooseX::Declare;


class WordGraph::Frame extends WordGraph::Object {
   use List::Util qw( first );


   has Words         => ( is => 'rw', isa => 'ArrayRef[WordGraph::Word]', default => sub { [] } );
   has Links         => ( is => 'rw', isa => 'ArrayRef[Pair[Data::GUID]]', default => sub { [] } );
   has Coordinates   => ( is => 'rw', isa => 'HashRef', default => sub { {} } );


   #-------------------------------------------------------------------------------
   method _composeRawData {
      return { 
         Words       => [ map { { Uid => $_->getUid()->as_string(), Mask => $_->getMask(), Hash => $_->getHash() } } @{ $self->Words } ],
         Links       => [ map { [ $_->[ 0 ]->as_string(), $_->[ 1 ]->as_string() ] } @{ $self->Links } ],
         Coordinates => { map { $_ => $self->Coordinates->{ $_ } } keys %{ $self->Coordinates } },
      };
   }


   #-------------------------------------------------------------------------------
   method _decomposeRawData( HashRef $RawData! ) {
      if( my $Words = $RawData->{Words} ) {
         $self->Words( [ map { WordGraph::Word->new( Uid => $_->{Uid}, Hash => $_->{Hash}, Mask => $_->{Mask} ) } @$Words ] );
      }
      if( my $Links = $RawData->{Links} ) {
         $self->Links( [ map { [ Data::GUID->from_string( $_->[ 0 ] ), Data::GUID->from_string( $_->[ 1 ] ) ] } @$Links ] );
      }
      if( my $Coordinates = $RawData->{Coordinates} ) {
         $self->Coordinates( $Coordinates );
      }
      return 1;
   }


   #-------------------------------------------------------------------------------
   method getWordByUid( Data::GUID $WordUid! ) {
      return first { $_->getUid() == $WordUid } @{ $self->Words };
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
   method getLinkedWords( WordGraph::Word $Word! ) {
      my $WordUid = $Word->getUid();
      my @LinkedWords = ();
      foreach my $Link ( @{ $self->Links } ) {
         if( $Link->[ 0 ] == $WordUid ) {
            push @LinkedWords, $self->getWordByUid( $Link->[ 1 ] );
         }
         elsif( $Link->[ 1 ] == $WordUid ) {
            push @LinkedWords, $self->getWordByUid( $Link->[ 0 ] );
         }
      }
      return @LinkedWords;
   }


   #-------------------------------------------------------------------------------
   method addWord( WordGraph::Word $Word! ) {
      push @{ $self->Words }, $Word;
      return $self->_save();
   }


   #-------------------------------------------------------------------------------
   method linkWords( WordGraph::Word $WordA!, WordGraph::Word $WordB! ) {
      my $UidsPair = [ map { $_->getUid() } ( $WordA, $WordB )];
      push @{ $self->Links }, $UidsPair;
      return $self->_save();
   }


   #-------------------------------------------------------------------------------
   method setCoordinates( WordGraph::Word $Word!, HashRef $Coordinates ) {
      $self->Coordinates->{ $Word->getUid() } = $Coordinates;
      return $self->_save();
   }

   
   #-------------------------------------------------------------------------------
   method getCoordinates( WordGraph::Word $Word! ) {
      return $self->Coordinates->{ $Word->getUid() };
   }
}
