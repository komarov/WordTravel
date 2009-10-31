use MooseX::Declare;
use WordGraph::Types;

class WordGraph::User {
   has Uid     => ( is => 'ro', isa => 'GUID', coerce => 1, required => 1 );
   has Guessed => ( is => 'ro', isa => 'ArrayRef[WordGraph::Word]', builder => '_buildGuessed' ); 
   

   #-------------------------------------------------------------------------------
   method _buildGuessed {
      return [];
   }
}
