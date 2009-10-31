use MooseX::Declare;
use WordGraph::Types;

class WordGraph::User extends WordGraph::Object {
   has Guessed => ( is => 'ro', isa => 'ArrayRef[WordGraph::Word]', builder => '_buildGuessed' ); 
   

   #-------------------------------------------------------------------------------
   method _buildGuessed {
      return [];
   }
}
