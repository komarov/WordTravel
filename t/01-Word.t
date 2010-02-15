use strict;
use warnings;
use utf8;
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
my $Model = WordGraph::Model->new( Storage => $Storage, ObjectClasses => [ qw( Word ) ] );

my $Word = $Model->createWord( Word => 'abc 123' );
ok(
   $Word->getMask() eq '... ...',
   'getMask works'
);
ok(
   $Word->verify( 'abc 123' ),
   'exact verify works'
);
ok(
   $Word->verify( 'aBc 123' ),
   'verify is case insensitive'
);
ok(
   !$Word->verify( 'abc abc' ),
   'verify does not pass for wrong strings'
);
$Word->delete();

my $UnicodeWord = $Model->createWord( Word => 'йцукен 123' );
ok(
   $UnicodeWord->verify( 'йцукен 123' ),
   'exact unicode verify works'
);
ok(
   $UnicodeWord->verify( 'йЦуКен 123' ),
   'case insensitive unicode verify works'
);
$UnicodeWord->delete();
