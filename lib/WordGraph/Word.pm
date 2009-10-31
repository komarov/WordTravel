use MooseX::Declare;
use WordGraph::Types;


class WordGraph::Word extends WordGraph::Object {
   has Word => ( is => 'ro', isa => 'Str' );


   #------------------------------------------------------------------------------- 
   method verify( Str $Word ) {
      return lc( $self->Word ) eq lc( $Word );
   }


   #-------------------------------------------------------------------------------
   method getMask {
      my $Mask = $self->Word;
      $Mask =~ s{\S}{.}g;
      return $Mask;
   }
}
