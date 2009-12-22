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
   this.getLinksCount = getLinksCount;

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

   for( var wordUID in this.Words ) {
      if( this.Words.hasOwnProperty( wordUID ) ) {
         if( DEBUG ) console.log(  this.Words[ wordUID ] );
         this.Words[ wordUID ].drawWord( paper, 3 );
      }
   }

   for( var index in this.Links ) {
      if( this.Links.hasOwnProperty( index ) ) {
         var link = this.Links[ index ];

         var hotSpot_0 =  this.Words[ link[ 0 ] ].hotSpot();
         var hotSpot_1 =  this.Words[ link[ 1 ] ].hotSpot();

         if( DEBUG ) console.log( 'hspots:', hotSpot_0, hotSpot_1, link );

         var path = paper.path( "M" + hotSpot_0.x + " " + hotSpot_0.y + "L" + hotSpot_1.x + " " + hotSpot_1.y ).attr( 'stroke', '#0f0' );
         path.toBack();
      }
   }
}

function getLinksCount( wordUID ) {

   var linksCount = 0;
   
   for( var index in this.Links ) {
      if( this.Links.hasOwnProperty( index ) ) {
         var link = this.Links[ index ];
         if( wordUID == link[ 0 ]  ) {
            linksCount++;
         }
         if( wordUID == link[ 1 ] ) {
            linksCount++;
         }
      }
   }

   return linksCount;
}

