use strict;
use warnings;
use Test::More qw( no_plan );

use lib 'lib';
use WordGraph::Types;
use_ok( 'WordGraph::User' );
use WordGraph::Word;

my $User = WordGraph::User->new();
ok(
   $User->isa( 'WordGraph::User' ),
   'user created successfully'
);

my $Word = WordGraph::Word->new( Word => 'abc' );
ok( 
   $User->_storeGuessedWord( $Word ),
   'guessed word stored successfully'
);
ok(
   $User->hasGuessed( $Word ),
   'stored guessed word now is really considered guessed'
);
my $AnotherWord = WordGraph::Word->new( Word => '123' );
ok(
   !$User->hasGuessed( $AnotherWord ),
   'unknown words are not considered guessed'
);
ok( 
   $User->_storeGuessedWord( $AnotherWord ),
   'another guessed word stored successfully'
);

my $SameUser = WordGraph::User->new( Uid => $User->getUid() );
ok(
   $SameUser->hasGuessed( $Word ) && $SameUser->hasGuessed( $AnotherWord ),
   'all instances of the same user consider this word as guessed'
);

my $NewWord = WordGraph::Word->new( Word => 'real' );
ok(
   !$User->guessWord( Word => $NewWord, Guess => 'unreal' ) && !$User->hasGuessed( $NewWord ),
   'wrong guess is blocked'
);
ok(
   $User->guessWord( Word => $NewWord, Guess => 'real' ) && $User->hasGuessed( $NewWord ),
   'correct guess leads to storing of guessed word'
);
$User->_delete();
