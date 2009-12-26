use MooseX::Declare;


class WordGraph::Object with WordGraph::Uid {
   use JSON;
   use IO::All -utf8;


   #-------------------------------------------------------------------------------
   method BUILD {
      $self->_load();
   }


   #-------------------------------------------------------------------------------
   method _getStorage {
      if( -e 'data/' . blessed( $self ) ) {
         return 'data/' . blessed( $self ) . '/' . $self->getUid();
      }
      else {
         return 'data/' . blessed( $self ) . $self->getUid();
      }
   }


   #-------------------------------------------------------------------------------
   method _composeRawData {
      return {};
   }


   #-------------------------------------------------------------------------------
   method _decomposeRawData( HashRef $RawData! ) {
      return 1;
   }


   #-------------------------------------------------------------------------------
   method _load {
      if( -e $self->_getStorage() ) {
         my $RawDataJson = io( $self->_getStorage() )->all;
         $self->_decomposeRawData( from_json( $RawDataJson ) );
         return 1;
      }
      else {
         return;
      }
   }


   #-------------------------------------------------------------------------------
   method _save {
      to_json( $self->_composeRawData() ) > io( $self->_getStorage() );
      return 1;
   }


   #-------------------------------------------------------------------------------
   method _delete {
      return unlink( $self->_getStorage() );
   }
}
