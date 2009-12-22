use strict;
use warnings;
use Test::More qw( no_plan );

use lib 'lib';
use WordGraph::Types;
use WordGraph::User;
use WordGraph::Word;
use WordGraph::Frame;

my $User = WordGraph::User->new();
ok(
   $User->isa( 'WordGraph::User' ),
   'user created successfully'
);

my $Word = WordGraph::Word->new( Word => 'abc' );
my $AnotherWord = WordGraph::Word->new( Word => '123' );
ok(
   $User->guessWord( Word => $Word, Guess => 'aBc' ) && $User->getGuess( $Word ) eq 'aBc',
   'guessed and stored exact guess'
);
ok(
   $User->guessWord( Word => $AnotherWord, Guess => '123' ),
   'guessed'
);

my $SameUser = WordGraph::User->new( Uid => $User->getUid() );
ok(
   $SameUser->isEqual( $User ),
   'created same user'
);
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
ok(
   !$User->guessWord( Word => $NewWord, Guess => 'real' ),
   'second guess has no effect'
);

my $SecretWord = WordGraph::Word->new( Word => 'secret' );
my $SecretWord2 = WordGraph::Word->new( Word => 'secret1' );
my @Words = ( $Word, $AnotherWord, $NewWord, $SecretWord, $SecretWord2 );
my $Frame = WordGraph::Frame->new( Words => \@Words );
$Frame->linkWords( $Word, $AnotherWord );
$Frame->linkWords( $AnotherWord, $NewWord );
$Frame->linkWords( $NewWord, $SecretWord );
$Frame->linkWords( $NewWord, $SecretWord2 );

ok(
   $User->guessWordInFrame( Frame => $Frame, Guess => 'secret' ),
   'guessed word in frame'
);
ok(
   !$User->guessWordInFrame( Frame => $Frame, Guess => 'secret' ),
   'second guess has no effect'
);

use Data::Dumper;
print Dumper $User->renderFrame( $Frame );

$User->_delete();
$Frame->_delete();
