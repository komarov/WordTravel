use MooseX::Declare;


class WordGraph::User extends WordGraph::Object with WordGraph::Uid {
   has Guessed => ( is => 'ro', isa => 'ArrayRef[Data::GUID]', lazy => 1, builder => '_buildGuessed' ); 
   

   #-------------------------------------------------------------------------------
   method _buildGuessed {
      return [];
   }
}
