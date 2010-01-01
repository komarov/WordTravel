use MooseX::Declare;


class WordGraph::User extends WordGraph::Object {
   use List::MoreUtils qw( none any );
   use List::Util qw( first );
   use Data::GUID;
   use IO::All -utf8;
   use JSON;


   has GuessedWords => ( is => 'rw', isa => 'ArrayRef[HashRef[Data::GUID|Str]]', default => sub{ [] } ); 
   

   #-------------------------------------------------------------------------------
   method _composeRawData {
      return { GuessedWords => [ map { { Uid => $_->{Uid}->as_string(), Word => $_->{Word} } } @{ $self->GuessedWords } ] };
   }


   #-------------------------------------------------------------------------------
   method _decomposeRawData( HashRef $RawData! ) {
      if( my $GuessedWords = $RawData->{GuessedWords} ) {
         $self->GuessedWords( [ map { { Uid => Data::GUID->from_string( $_->{Uid} ), Word => $_->{Word} } } @$GuessedWords ] );
         return 1;
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method _storeGuessedWord( WordGraph::Word :$Word, Str :$Guess ) {
      if( none { $Word->getUid() == $_->{Uid} } @{ $self->GuessedWords } or !scalar @{ $self->GuessedWords } ) {
         push @{ $self->GuessedWords }, { Uid => $Word->getUid(), Word => $Guess };
         $self->_save();
         return 1;
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method guessWord( WordGraph::Word :$Word!, Str :$Guess! ) {
      if( !$self->hasGuessed( $Word ) && $Word->verify( $Guess ) ) {
         return $self->_storeGuessedWord( Word => $Word, Guess => $Guess );
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method hasGuessed( WordGraph::Word $Word! ) {
      return any { $Word->getUid() == $_->{Uid} } @{ $self->GuessedWords };
   }


   #-------------------------------------------------------------------------------
   method getGuess( WordGraph::Word $Word! ) {
      if( my $StoredGuess = first { $_->{Uid} == $Word->getUid() } @{ $self->GuessedWords } ) {
         return $StoredGuess->{Word};
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method renderFrame( WordGraph::Frame $Frame! ) {
      my %VisibleWords = ();
      foreach my $Word ( $Frame->getWords() ) {
         if( !exists $VisibleWords{ $Word->getUid() } ) {
            if( $self->hasGuessed( $Word ) ) {
               $VisibleWords{ $Word->getUid() } = $self->getGuess( $Word );
               foreach my $LinkedWord ( $Frame->getLinkedWords( $Word ) ) {
                  $VisibleWords{ $LinkedWord->getUid() } = $self->hasGuessed( $LinkedWord ) ? $self->getGuess( $LinkedWord ) : $LinkedWord->getMask();
               }
            }
         }
      }
      my @VisibleLinks = map { [ $_->[ 0 ]->as_string(), $_->[ 1 ]->as_string() ] } 
                         grep { exists $VisibleWords{ $_->[ 0 ] } || exists $VisibleWords{ $_->[ 1 ] } } 
                         $Frame->getLinks();
      my %Coordinates = map { $_ => $Frame->getCoordinates( $Frame->getWordByUid( Data::GUID->from_string( $_ ) ) ) } keys %VisibleWords;
      return {
         Words       => \%VisibleWords,
         Links       => \@VisibleLinks,
         Coordinates => \%Coordinates,
      };
   }


   #-------------------------------------------------------------------------------
   method guessWordInFrame( WordGraph::Frame :$Frame!, Str :$Guess! ) {
      return any { $self->guessWord( Word => $_, Guess => $Guess ) } $Frame->getWords();
   }


   #-------------------------------------------------------------------------------
   # Returns { FrameUid => { Title => '' }, }
   method getFrameList {
      if( my $FrameListJson = io( 'data/FrameList' )->all ) {
         my $FrameList = decode_json( $FrameListJson );
         my %CompletedFrameUids = map { ( "$_" => 1 ) } $self->_getCompletedFrameUids();
         foreach my $FrameUid ( keys %$FrameList ) {
            if( $CompletedFrameUids{ $FrameUid } ) {
               $FrameList->{ $FrameUid }->{Completed} = 1;
            }
         }
         return $FrameList;
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method _getCompletedFrameUids {
      # !!! implement later
      return;
   }
}
