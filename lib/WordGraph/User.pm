use MooseX::Declare;


class WordGraph::User extends WordGraph::Object {
   use List::MoreUtils qw( none any );
   use Data::GUID;


   has GuessedWordUids => ( is => 'rw', isa => 'ArrayRef[Data::GUID]', default => sub{ [] } ); 
   

   #-------------------------------------------------------------------------------
   method _composeRawData {
      return { GuessedWordUids => [ map { $_->as_string() } @{ $self->GuessedWordUids } ] };
   }


   #-------------------------------------------------------------------------------
   method _decomposeRawData( HashRef $RawData! ) {
      if( my $GuessedWordUids = $RawData->{GuessedWordUids} ) {
         $self->GuessedWordUids( [ map { Data::GUID->from_string( $_ ) } @$GuessedWordUids ] );
         return 1;
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method _storeGuessedWord( WordGraph::Word $Word! ) {
      if( none { $Word->getUid() == $_ } @{ $self->GuessedWordUids } or !scalar @{ $self->GuessedWordUids } ) {
         push @{ $self->GuessedWordUids }, $Word->getUid();
         $self->_save();
         return 1;
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method guessWord( WordGraph::Word :$Word!, Str :$Guess! ) {
      if( $Word->verify( $Guess ) ) {
         return $self->_storeGuessedWord( $Word );
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method hasGuessed( WordGraph::Word $Word! ) {
      return any { $Word->getUid() == $_ } @{ $self->GuessedWordUids };
   }


   #-------------------------------------------------------------------------------
   method renderFrame( WordGraph::Frame $Frame! ) {
      my %VisibleWords = ();
      foreach my $Word ( $Frame->getWords() ) {
         if( !exists $VisibleWords{ $Word->getUid() } ) {
            if( $self->hasGuessed( $Word ) ) {
               $VisibleWords{ $Word->getUid() } = $Word->getWord();
               foreach my $LinkedWord ( $Frame->getLinkedWords( $Word ) ) {
                  $VisibleWords{ $LinkedWord->getUid() } = $self->hasGuessed( $LinkedWord ) ? $LinkedWord->getWord() : $LinkedWord->getMask();
               }
            }
         }
      }
      my @VisibleLinks = map { [ $_->[ 0 ]->as_string(), $_->[ 1 ]->as_string() ] } 
                         grep { exists $VisibleWords{ $_->[ 0 ] } || exists $VisibleWords{ $_->[ 1 ] } } 
                         $Frame->getLinks();
      return {
         Words => \%VisibleWords,
         Links => \@VisibleLinks,
      };
   }
}
