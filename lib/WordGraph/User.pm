use MooseX::Declare;


class WordGraph::User extends WordGraph::Object {
   use List::MoreUtils qw( none any );
   use Data::GUID;


   has GuessedWordUids => ( is => 'rw', isa => 'ArrayRef[Data::GUID]', default => sub{ [] } ); 
   

   #-------------------------------------------------------------------------------
   method BUILD {
      $self->_load();
   }


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
      if( none { $Word->hasUid( $_ ) } @{ $self->GuessedWordUids } or !scalar @{ $self->GuessedWordUids } ) {
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
      return any { $Word->hasUid( $_ ) } @{ $self->GuessedWordUids };
   }
}
