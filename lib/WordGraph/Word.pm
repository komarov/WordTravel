use MooseX::Declare;


class WordGraph::Word with WordGraph::Uid {
   has Word => ( is => 'ro', isa => 'Str' );


   #-------------------------------------------------------------------------------
   method getWord {
      return $self->Word;
   }


   #------------------------------------------------------------------------------- 
   method verify( Maybe[Str] $Word! ) {
      return lc( $self->Word ) eq lc( $Word );
   }


   #-------------------------------------------------------------------------------
   method getMask {
      my $Mask = $self->Word;
      $Mask =~ s{\S}{.}g;
      return $Mask;
   }
}
