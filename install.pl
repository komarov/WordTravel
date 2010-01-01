#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib';
use WordGraph;
use WordGraph::Word;

my $WordGraph = WordGraph->new();

my $Frame = $WordGraph->getFrame( 'D79E7F3E-F721-11DE-9056-D35FA7517805' );

my $Word = WordGraph::Word->new( Word => 'abc' );
my $AnotherWord = WordGraph::Word->new( Word => '123' );
my $NewWord = WordGraph::Word->new( Word => 'real' );
my $SecretWord = WordGraph::Word->new( Word => 'secret' );
my $SecretWord2 = WordGraph::Word->new( Word => 'secret1' );
my @Words = ( $Word, $AnotherWord, $NewWord, $SecretWord, $SecretWord2 );
$Frame->addWord( $_ ) foreach @Words;

$Frame->linkWords( $Word, $AnotherWord );
$Frame->linkWords( $AnotherWord, $NewWord );
$Frame->linkWords( $NewWord, $SecretWord );
$Frame->linkWords( $NewWord, $SecretWord2 );

$Frame->setCoordinates( $_, { X => int( rand( 50 ) ), Y => int( rand( 50 ) ) } ) foreach @Words;
