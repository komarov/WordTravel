package WordGraph::Types;
use Moose::Util::TypeConstraints;

class_type( 'WordGraph::Model' )          unless find_type_constraint( 'WordGraph::Model' );
class_type( 'WordGraph::Model::Object' )  unless find_type_constraint( 'WordGraph::Model::Object' );
foreach my $ObjectClass ( qw( User Frame Word ) ) {
   class_type( 'WordGraph::Model::Object::' . $ObjectClass )  unless find_type_constraint( 'WordGraph::Model::Object::' . $ObjectClass );
}

subtype 'WordGraph::Model::Storage' => as class_type( 'KiokuDB' );

subtype 'Pair' => as 'ArrayRef' => where { @$_ == 2  };

sub Moose::Meta::Attribute::Custom::Trait::WordGraph::Model::NotStorable::register_implementation { 'WordGraph::Model::NotStorable' }

1;
