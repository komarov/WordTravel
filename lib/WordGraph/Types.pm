package WordGraph::Types;
use Moose::Util::TypeConstraints;
use MooseX::Types::Data::GUID;

class_type( 'WordGraph' ) unless find_type_constraint( 'WordGraph' );
class_type( 'WordGraph::Object' ) unless find_type_constraint( 'WordGraph::Object' );
class_type( 'WordGraph::Word' ) unless find_type_constraint( 'WordGraph::Word' );
class_type( 'WordGraph::User' ) unless find_type_constraint( 'WordGraph::User' );
class_type( 'WordGraph::Frame' ) unless find_type_constraint( 'WordGraph::Frame' );

subtype 'Pair' => as 'ArrayRef' => where { @$_ == 2  };
1;
