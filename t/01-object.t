use strict;
use warnings;
use utf8;
use Test::More qw( no_plan );
use MooseX::Declare;

use lib 'lib';
use WordGraph::Object;

my $Class = class extends WordGraph::Object {
   has RawData => ( is => 'rw', isa => 'HashRef', default => sub { {} } );


   #-------------------------------------------------------------------------------
   method _composeRawData {
      return $self->RawData;
   }


   #-------------------------------------------------------------------------------
   method _decomposeRawData( $RawData ) {
      $self->RawData( $RawData );
      return 1;
   }
};
my $Object = $Class->new_object();
ok(
   $Object->isa( 'WordGraph::Object' ),
   'object creation works'
);
my $Uid = $Object->getUid();

my ( $Key, $Value ) = ( 'фыва', 'олдж' );

$Object->RawData->{ $Key } = $Value;
ok(
   $Object->_save(),
   'object saved successfully'
);

my $SameObject = $Class->new_object( Uid => $Uid );
ok(
   $Object->isEqual( $SameObject ),
   'objects have same uids'
);
ok(
   $SameObject->_load(),
   'object loaded successfully'
);
ok(
   $SameObject->RawData->{ $Key } eq $Value,
   'stored data retrieved successfully'
);

$Object->_delete();
