use strict;
use warnings;
use Test::More qw( no_plan );

use lib 'lib';
use WordGraph::Types;
use_ok( 'WordGraph::Frame' );
use WordGraph::Word;

my $Word1 = WordGraph::Word->new( Word => '123' );
my $Word2 = WordGraph::Word->new( Word => 'abc' );
my $Links = [ [ $Word1->getUid(), $Word2->getUid() ] ];
my $Frame = WordGraph::Frame->new( Words => [ $Word1, $Word2 ], Links => $Links );
ok(
   $Frame->isa( 'WordGraph::Frame' ),
   'frame was created successfully'
);
$Frame->_save();

my $SameFrame = WordGraph::Frame->new( Uid => $Frame->getUid() );
my ( $Linked ) = $SameFrame->getLinkedWords( $Word1->getUid() );
ok(
   $Linked->isEqual( $Word2 ),
   'getLinkedWords works'
);

my $Word3 = WordGraph::Word->new( Word => 'zxcvb' );

ok(
   $Frame->addWord( $Word3 ),
   'word was added successfully'
);
ok(
   $Frame->linkWords( [ $Word1->getUid(), $Word3->getUid() ] ),
   'words were linked successfully'
);
my @Linked = $Frame->getLinkedWords( $Word1->getUid() );
ok(
   scalar @Linked == 2,
   'both linked words were found'
);

$SameFrame->_delete();
