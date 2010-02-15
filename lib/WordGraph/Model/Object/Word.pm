use MooseX::Declare;


class WordGraph::Model::Object::Word extends WordGraph::Model::Object {
   use Digest::MD5 qw( md5_hex );
   use Encode qw( encode_utf8 );


   has Hash => ( is => 'ro', isa => 'Str', required => 1 );
   has Mask => ( is => 'ro', isa => 'Str', required => 1 );


   #-------------------------------------------------------------------------------
   method BUILDARGS( ClassName $Class: %Parameters ) {
      my $Args = $Class->SUPER::BUILDARGS( %Parameters );
      my $Word = $Parameters{Word};
      my $Uid  = $Parameters{Uid};
      if( $Word ) {
         $Args->{Hash} = _hash( $Word );
         $Args->{Mask} = _mask( $Word );
      }
      return $Args;
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
      return md5_hex( encode_utf8( lc( shift ) ) );
   }


   #-------------------------------------------------------------------------------
   sub _mask {
      my $Mask = shift;
      $Mask =~ s{\S}{.}g;
      return $Mask;
   }
}
