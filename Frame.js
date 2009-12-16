//Frame.js
//Contains the description of the Frame object

function getFrame() {

   var frame = {
      'Links': [
         [
            '8EC0B16E-E7EB-11DE-B3BD-C724A05985A0',
            '8EC99946-E7EB-11DE-B3BD-C724A05985A0'
         ],
         [
            '8EC99946-E7EB-11DE-B3BD-C724A05985A0',
            '8ED02950-E7EB-11DE-B3BD-C724A05985A0'
         ],
         [
            '8ED02950-E7EB-11DE-B3BD-C724A05985A0',
            '8ED9AF20-E7EB-11DE-B3BD-C724A05985A0'
         ],
         [
            '8ED02950-E7EB-11DE-B3BD-C724A05985A0',
            '8EDA547A-E7EB-11DE-B3BD-C724A05985A0'
         ]
      ],
      'Words': {
         '8EC0B16E-E7EB-11DE-B3BD-C724A05985A0': 'aBc',
         '8ED9AF20-E7EB-11DE-B3BD-C724A05985A0': 'secretskdlgksjdklgjhsdklgjdhslkdh',
         '8ED02950-E7EB-11DE-B3BD-C724A05985A0': 'real',
         '8EC99946-E7EB-11DE-B3BD-C724A05985A0': '123',
         '8EDA547A-E7EB-11DE-B3BD-C724A05985A0': '.......'
      }
   };

   return frame;
}

function Frame( frameUID ) {
   
   this.Words = {};
   this.UID = frameUID;

//----methods----
//   this.setWords = setWords;
   this.render = render;
   this.receiveFrameByUID = receiveFrameByUID;
   this.setWords = setWords;

}

function receiveFrameByUID( frameUID ) {

   var frame = getFrame();
   this.setWords( frame );

}

function setWords( frame ) {

   var words = {};

   for( var wordUID in frame.Words ) {
      if( frame.Words.hasOwnProperty( wordUID ) ) {
         words[ wordUID ] = new Word( frame.Words[ wordUID ], getLinks( frame, wordUID ) );
         if( DEBUG ) console.log( words[ wordUID ] );
      }
   }

   this.Words = words;
}

function render( paper ) {

   for( var wordUID in this.Words ) {
      if( this.Words.hasOwnProperty( wordUID ) ) {
         if( DEBUG ) console.log(  this.Words[ wordUID ] );
         this.Words[ wordUID ].drawWord( paper, 3 );
      }
   }
}
