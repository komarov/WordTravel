//Frame.js
//Contains the description of the Frame object

function getFrame( frameUID ) {

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
   this.Links = [];
   this.UID = frameUID;

//----methods----
   this.render = render;
   this.receiveFrameByUID = receiveFrameByUID;

//----additional actions----
   this.receiveFrameByUID( frameUID );
}

function receiveFrameByUID( frameUID ) {

   var frame = getFrame( frameUID );
   if( DEBUG ) console.log( frame );

   for( var wordUID in frame.Words ) {
      if( frame.Words.hasOwnProperty( wordUID ) ) {
         this.Words[ wordUID ] = new Word( frame.Words[ wordUID ] );
         if( DEBUG ) console.log( this.Words[ wordUID ] );
      }
   }

   this.Links = frame.Links;
}

function render( paper ) {

   var rectangles = {};

   for( var wordUID in this.Words ) {
      if( this.Words.hasOwnProperty( wordUID ) ) {
         if( DEBUG ) console.log(  this.Words[ wordUID ] );
         rectangles[ wordUID ] = this.Words[ wordUID ].drawWord( paper, 3 );
      }
   }

   if( DEBUG ) console.log( rectangles );

   for( var index in this.Links ) {
      if( this.Links.hasOwnProperty( index ) ) {
         var link = this.Links[ index ];

         var hotSpot_0 =  rectangles[ link[ 0 ] ].getHotSpot();
         var hotSpot_1 =  rectangles[ link[ 1 ] ].getHotSpot();

         var path = paper.path( "M" + hotSpot_0.x + " " + hotSpot_0.y + "L" + hotSpot_1.x + " " + hotSpot_1.y ).attr( 'stroke', '#0f0' );
         path.toBack();
      }
   }
}
