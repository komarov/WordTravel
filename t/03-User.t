use strict;
use warnings;
use Test::More qw( no_plan );
use KiokuDB;
use KiokuDB::Backend::Files;

use lib 'lib';
use WordGraph::Model;

my $Storage = KiokuDB->new(
   backend => KiokuDB::Backend::Files->new(
      dir        => 't/data',
      serializer => 'json',
   ),
);
my $Scope = $Storage->new_scope;
my $Model = WordGraph::Model->new( Storage => $Storage, ObjectClasses => [ qw( User Frame Word ) ] );

my $User = $Model->createUser();
my $Word = $Model->createWord( Word => 'abc' );
my $AnotherWord = $Model->createWord( Word => '123' );
ok(
   $User->guessWord( Word => $Word, Guess => 'aBc' ) && $User->getGuess( $Word ) eq 'aBc',
   'guessed and stored exact guess'
);
ok(
   $User->guessWord( Word => $AnotherWord, Guess => '123' ),
   'guessed'
);

my $SameUser = $Model->getUser( $User->getUid() );
ok(
   $SameUser->isEqual( $User ),
   'created same user'
);
ok(
   $SameUser->hasGuessed( $Word ) && $SameUser->hasGuessed( $AnotherWord ),
   'all instances of the same user consider this word as guessed'
);

my $NewWord = $Model->createWord( Word => 'real' );
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

my $SecretWord = $Model->createWord( Word => 'secret' );
my $SecretWord2 = $Model->createWord( Word => 'secret1' );
my @Words = ( $Word, $AnotherWord, $NewWord, $SecretWord, $SecretWord2 );
my $Frame = $Model->createFrame( Words => \@Words );
$Frame->linkWords( $Word, $AnotherWord );
$Frame->linkWords( $AnotherWord, $NewWord );
$Frame->linkWords( $NewWord, $SecretWord );
$Frame->linkWords( $NewWord, $SecretWord2 );

$Frame->setCoordinates( $_, { X => int( rand( 50 ) ), Y => int( rand( 50 ) ) } ) foreach @Words;

ok(
   $User->guessWordInFrame( Frame => $Frame, Guess => 'secret' ),
   'guessed word in frame'
);
ok(
   !$User->guessWordInFrame( Frame => $Frame, Guess => 'secret' ),
   'second guess has no effect'
);

ok(
   $User->getFrameList(),
   'dummy getFrameList works'
);

$User->delete();
$Frame->delete();
