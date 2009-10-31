use MooseX::Declare;
use WordGraph::Types;


class WordGraph::Word {
   use Data::GUID;


   has Uid  => ( is => 'ro', isa => 'Data::GUID', coerce => 1, lazy => 1, builder => '_buildUid' );
   has Word => ( is => 'ro', isa => 'Str' );


   #-------------------------------------------------------------------------------
   method _buildUid {
      return Data::GUID->new();
   }


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
