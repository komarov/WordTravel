use strict;
use warnings;
use Test::More qw( no_plan );
use KiokuDB;
use KiokuDB::Backend::Files;

use lib 'lib';
use WordGraph::Types;
use WordGraph::Model;

my $Storage = KiokuDB->new(
   backend => KiokuDB::Backend::Files->new(
      dir        => 't/data',
      serializer => 'json',
   ),
);
my $Scope = $Storage->new_scope;
my $Model = WordGraph::Model->new( Storage => $Storage, ObjectClasses => [ qw( Word Frame ) ] );

my $Word1 = $Model->createWord( Word => '123' );
my $Word2 = $Model->createWord( Word => 'abc' );
my $Links = [ [ $Word1->getUid(), $Word2->getUid() ] ];
my $Frame = $Model->createFrame( Words => [ $Word1, $Word2 ], Links => $Links );
ok(
   $Frame->isa( 'WordGraph::Model::Object::Frame' ),
   'frame was created successfully'
);

ok(
   $Frame->getWordByUid( $Word1->getUid() )->isEqual( $Word1 ),
   'getWordByUid works'
);

my $SameFrame = $Model->getFrame( $Frame->getUid() );
my ( $Linked ) = $SameFrame->getLinkedWords( $Word1 );
ok(
   $Linked->isEqual( $Word2 ),
   'getLinkedWords works'
);

my $Word3 = $Model->createWord( Word => 'zxcvb' );

ok(
   $Frame->addWord( $Word3 ),
   'word was added successfully'
);
ok(
   $Frame->linkWords( $Word1, $Word3 ),
   'words were linked successfully'
);
my @Linked = $Frame->getLinkedWords( $Word1 );
ok(
   scalar @Linked == 2,
   'both linked words were found'
);
ok(
   $Frame->setCoordinates( $Word1, { X => 1, Y => 2 } ),
   'setCoordinates works'
);
$Frame->delete();
