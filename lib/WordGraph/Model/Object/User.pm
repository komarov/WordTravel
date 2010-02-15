use MooseX::Declare;


class WordGraph::Model::Object::User extends WordGraph::Model::Object {
   use List::MoreUtils qw( none any );
   use List::Util qw( first );
   use IO::All -utf8;
   use JSON;


   has GuessedWords => ( is => 'rw', isa => 'ArrayRef[HashRef[Str]]', default => sub{ [] } ); 


   #-------------------------------------------------------------------------------
   method _storeGuessedWord( WordGraph::Model::Object::Word :$Word, Str :$Guess ) {
      if( none { $Word->getUid() eq $_->{Uid} } @{ $self->GuessedWords } or !scalar @{ $self->GuessedWords } ) {
         push @{ $self->GuessedWords }, { Uid => $Word->getUid(), Word => $Guess };
         return 1;
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method guessWord( WordGraph::Model::Object::Word :$Word!, Str :$Guess! ) {
      if( !$self->hasGuessed( $Word ) && $Word->verify( $Guess ) ) {
         return $self->_storeGuessedWord( Word => $Word, Guess => $Guess );
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method hasGuessed( WordGraph::Model::Object::Word $Word! ) {
      return any { $Word->getUid() eq $_->{Uid} } @{ $self->GuessedWords };
   }


   #-------------------------------------------------------------------------------
   method getGuess( WordGraph::Model::Object::Word $Word! ) {
      if( my $StoredGuess = first { $_->{Uid} eq $Word->getUid() } @{ $self->GuessedWords } ) {
         return $StoredGuess->{Word};
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method renderFrame( WordGraph::Model::Object::Frame $Frame! ) {
      my %VisibleWords = ();
      foreach my $Word ( $Frame->getWords() ) {
         if( $self->hasGuessed( $Word ) ) {
            $VisibleWords{ $Word->getUid() } = $self->getGuess( $Word );
            foreach my $LinkedWord ( $Frame->getLinkedWords( $Word ) ) {
               $VisibleWords{ $LinkedWord->getUid() } = $self->hasGuessed( $LinkedWord ) ? $self->getGuess( $LinkedWord ) : $LinkedWord->getMask();
            }
         }
      }
      my @VisibleLinks = grep { exists $VisibleWords{ $_->[ 0 ] } and exists $VisibleWords{ $_->[ 1 ] } } 
                         $Frame->getLinks();
      my %Coordinates = map { $_ => $Frame->getCoordinates( $Frame->getWordByUid( $_ ) ) } keys %VisibleWords;
      return {
         Words       => \%VisibleWords,
         Links       => \@VisibleLinks,
         Coordinates => \%Coordinates,
      };
   }


   #-------------------------------------------------------------------------------
   method guessWordInFrame( WordGraph::Model::Object::Frame :$Frame!, Str :$Guess! ) {
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
