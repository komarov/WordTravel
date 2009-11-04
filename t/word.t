use strict;
use warnings;
use utf8;
use Test::More qw( no_plan );

use lib 'lib';
use_ok( 'WordGraph::Word' );

my $Word = WordGraph::Word->new( Word => 'abc 123' );
ok(
   $Word->getWord() eq 'abc 123',
   'getWord works'
);
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

my $UnicodeWord = WordGraph::Word->new( Word => 'йцукен 123' );
ok(
   $UnicodeWord->verify( 'йцукен 123' ),
   'exact unicode verify works'
);
ok(
   $UnicodeWord->verify( 'йЦуКен 123' ),
   'case insensitive unicode verify works'
);
