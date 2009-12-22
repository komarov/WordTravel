use MooseX::Declare;


class WordGraph::Word with WordGraph::Uid {
   use Digest::MD5 qw( md5 );
   use Encode qw( encode_utf8 );


   has Hash => ( is => 'ro', isa => 'Str', required => 1 );
   has Mask => ( is => 'ro', isa => 'Str', required => 1 );


   #-------------------------------------------------------------------------------
   sub BUILDARGS {
      my $class = shift;

      my %Parameters = @_;
      my $Word = $Parameters{Word};
      my $Uid  = $Parameters{Uid};
      if( $Word ) {
         my $Args = { Hash => _hash( $Word ), Mask => _mask( $Word ) };
         if( $Uid ) {
            $Args->{Uid} = $Uid;
         }
         return $Args;
      }
      else {
         return $class->SUPER::BUILDARGS( @_ );
      }
   }


   #-------------------------------------------------------------------------------
   method getHash {
      return $self->Hash;
   }


   #-------------------------------------------------------------------------------
   method getMask {
      return $self->Mask;
   }


   #------------------------------------------------------------------------------- 
   method verify( Maybe[Str] $Guess! ) {
      return $self->getHash() eq _hash( $Guess ) && $self->getMask() eq _mask( $Guess );
   }


   #-------------------------------------------------------------------------------
   sub _hash {
      return md5( encode_utf8( lc( shift ) ) );
   }


   #-------------------------------------------------------------------------------
   sub _mask {
      my $Mask = shift;
      $Mask =~ s{\S}{.}g;
      return $Mask;
   }
}
