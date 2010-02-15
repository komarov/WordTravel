use strict;
use warnings;
use Test::More qw( no_plan );
use KiokuDB;
use KiokuDB::Backend::Files;
use MooseX::Declare;
use List::Compare;

use lib 'lib';
use WordGraph::Model;

my $Storage = KiokuDB->new(
   backend => KiokuDB::Backend::Files->new(
      dir        => 't/data',
      serializer => 'json',
   ),
);
my $Scope = $Storage->new_scope;
my $Model = WordGraph::Model->new( Storage => $Storage, ObjectClasses => [ qw( Test ) ] );

my $Class = class extends WordGraph::Model::Object {
   has TestAttribute1 => ( is => 'ro' );
   has TestAttribute2 => ( is => 'ro', traits => [ qw( WordGraph::Model::NotStorable ) ], default => 'abc' );
};
my $Object = $Class->name->new( Model => $Model );
#-------------------------------------------------------------------------------
ok(
   $Object->isa( 'WordGraph::Model::Object' ),
   'Object creation works'
);


my $Compare = List::Compare->new(
   [ map { $_->name } grep { !$_->does( 'WordGraph::Model::NotStorable' ) } $Object->meta->get_all_attributes() ],
   [ qw( Uid TestAttribute1 ) ]
);
#-------------------------------------------------------------------------------
ok(
   $Compare->is_LequivalentR(),
   'NotStorable things are filtered out'
);
$Compare = List::Compare->new(
   [ map { $_->name } grep { !$_->does( 'KiokuDB::DoNotSerialize' ) } $Object->meta->get_all_attributes() ],
   [ map { $_->name } grep { !$_->does( 'WordGraph::Model::NotStorable' ) } $Object->meta->get_all_attributes() ],
);
#-------------------------------------------------------------------------------
ok(
   $Compare->is_LequivalentR(),
   'Our trait WordGraph::Model::NotStorable draws KiokuDB::DoNotSerialize'
);
$Object->delete();


class WordGraph::Model::Object::Test extends WordGraph::Model::Object {
   has TestAttribute => ( is => 'rw', trigger => sub { $_[ 0 ]->update() } );
}

my $TestObject = WordGraph::Model::Object::Test->new( Model => $Model, TestAttribute => 123 );
$TestObject->TestAttribute( 456 );
$TestObject->delete();

my $NewObject = $Model->getTest();
ok(
   $NewObject->isa( 'WordGraph::Model::Object::Test' ),
   'Dynamic getObjectClass works'
);

$NewObject->delete();
