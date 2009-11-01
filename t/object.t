use strict;
use warnings;
use utf8;
use Test::More qw( no_plan );

use lib 'lib';
use_ok( 'WordGraph::Object' );

my $Object = WordGraph::Object->new();
ok(
   $Object->isa( 'WordGraph::Object' ),
   'object creation works'
);
my $Uid = $Object->Uid;

my ( $Key, $Value ) = ( 'фыва', 'олдж' );

$Object->RawData->{ $Key } = $Value;
ok(
   $Object->_save(),
   'object saved successfully'
);

my $SameObject = WordGraph::Object->new( Uid => $Uid );
ok(
   $SameObject->_load(),
   'object loaded successfully'
);
ok(
   $SameObject->RawData->{ $Key } eq $Value,
   'stored data retrieved successfully'
);

$Object->_delete();
