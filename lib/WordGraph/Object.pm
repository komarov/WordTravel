use MooseX::Declare;


class WordGraph::Object with WordGraph::Uid {
   use JSON;
   use IO::All -utf8;


   has RawData => ( is => 'rw', isa => 'HashRef', default => sub { {} } );


   #-------------------------------------------------------------------------------
   method _getStorage {
      return 'data/' . $self->Uid;
   }


   #-------------------------------------------------------------------------------
   method _load {
      my $RawDataJson = io( $self->_getStorage() )->all;
      $self->RawData( from_json( $RawDataJson ) );
      return 1;
   }


   #-------------------------------------------------------------------------------
   method _save {
      to_json( $self->RawData ) > io( $self->_getStorage() );
      return 1;
   }


   #-------------------------------------------------------------------------------
   method _delete {
      return unlink( $self->_getStorage() );
   }
}
