use MooseX::Declare;


class WordGraph::User extends WordGraph::Object {
   use List::MoreUtils qw( none any );
   use Data::GUID;


   has GuessedWords => ( is => 'rw', isa => 'ArrayRef[Data::GUID]', default => sub{ [] } ); 
   

   #-------------------------------------------------------------------------------
   method BUILD {
      $self->_load();
   }


   #-------------------------------------------------------------------------------
   method _composeRawData {
      return { GuessedWords => [ map { $_->as_string() } @{ $self->GuessedWords } ] };
   }


   #-------------------------------------------------------------------------------
   method _decomposeRawData( HashRef $RawData! ) {
      if( my $GuessedWords = $RawData->{GuessedWords} ) {
         $self->GuessedWords( [ map { Data::GUID->from_string( $_ ) } @$GuessedWords ] );
         return 1;
      }
      return;
   }


   #-------------------------------------------------------------------------------
   method _storeGuessedWord( WordGraph::Word $Word! ) {
      if( none { $Word->hasUid( $_ ) } @{ $self->GuessedWords } or !scalar @{ $self->GuessedWords } ) {
         push @{ $self->GuessedWords }, $Word->getUid();
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
      return any { $Word->hasUid( $_ ) } @{ $self->GuessedWords };
   }
}
