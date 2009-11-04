use MooseX::Declare;


class WordGraph::Frame extends WordGraph::Object {
   use List::Util qw( first );


   has Words => ( is => 'rw', isa => 'ArrayRef[WordGraph::Word]', default => sub { [] } );
   has Links => ( is => 'rw', isa => 'ArrayRef[Pair[Data::GUID]]', default => sub { [] } );


   #-------------------------------------------------------------------------------
   method _composeRawData {
      return { 
         Words => [ map { { Uid => $_->getUid()->as_string(), Word => $_->getWord() } } @{ $self->Words } ],
         Links => [ map { [ $_->[ 0 ]->as_string(), $_->[ 1 ]->as_string() ] } @{ $self->Links } ]
      };
   }


   #-------------------------------------------------------------------------------
   method _decomposeRawData( HashRef $RawData! ) {
      if( my $Words = $RawData->{Words} ) {
         $self->Words( [ map { WordGraph::Word->new( Uid => $_->{Uid}, Word => $_->{Word} ) } @$Words ] );
      }
      if( my $Links = $RawData->{Links} ) {
         $self->Links( [ map { [ Data::GUID->from_string( $_->[ 0 ] ), Data::GUID->from_string( $_->[ 1 ] ) ] } @$Links ] );
      }
      return 1;
   }


   #-------------------------------------------------------------------------------
   method getWordByUid( Data::GUID $WordUid ) {
      return first { $_->getUid() == $WordUid } @{ $self->Words };
   }


   #-------------------------------------------------------------------------------
   method getLinkedWords( Data::GUID $WordUid ) {
      my @LinkedWords = ();
      foreach my $Link ( @{ $self->Links } ) {
         my $Index;
         if( $Link->[ 0 ] == $WordUid ) {
            $Index = 1;
         }
         elsif( $Link->[ 1 ] == $WordUid ) {
            $Index = 0;
         }
         push @LinkedWords, $self->getWordByUid( $Link->[ $Index ] );
      }
      return @LinkedWords;
   }


   #-------------------------------------------------------------------------------
   method addWord( WordGraph::Word $Word ) {
      push @{ $self->Words }, $Word;
      return $self->_save();
   }


   #-------------------------------------------------------------------------------
   method linkWords( Pair[Data::GUID] $UidsPair ) {
      push @{ $self->Links }, $UidsPair;
      return $self->_save();
   }
}
