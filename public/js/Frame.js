//Contains the description of the Frame object


function createFrame( Options ) {
   
   var that = createObject( Options );
   that.UID = Options.UID;

   var Paper = that.getResource( 'Paper' );

   function getFrameData() {

      var FrameData = {
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
         },
         'Coordinates': {
            '8EC0B16E-E7EB-11DE-B3BD-C724A05985A0': { X: 0, Y: 0 },
            '8ED9AF20-E7EB-11DE-B3BD-C724A05985A0': { X: 0, Y: 10 },
            '8ED02950-E7EB-11DE-B3BD-C724A05985A0': { X: 10, Y: 20 },
            '8EC99946-E7EB-11DE-B3BD-C724A05985A0': { X: 20, Y: 30 },
            '8EDA547A-E7EB-11DE-B3BD-C724A05985A0': { X: 30, Y: 40 }
         }
      };

      return FrameData;
   }

   var FrameData = getFrameData();
   var Links = FrameData.Links;
   var Words = {};

   var WordsData = FrameData.Words;
   for( var WordUID in WordsData ) {
      if( WordsData.hasOwnProperty( WordUID ) ) {
         Words[ WordUID ] = createWord( { Text: WordsData[ WordUID ], Context: that } );
         Words[ WordUID ].setCoordinates( FrameData.Coordinates[ WordUID ] );         
         if( DEBUG ) console.log( Words[ WordUID ] );
      }
   }

   that.render = function() {

      var CornerRound = 3;
      for( var wordUID in Words ) {
         if( Words.hasOwnProperty( wordUID ) ) {
            if( DEBUG ) console.log(  Words[ wordUID ] );
            Words[ wordUID ].drawWord( CornerRound );
         }
      }

      for( var index in Links ) {
         if( Links.hasOwnProperty( index ) ) {
            var Link = Links[ index ];

            var HotSpot_0 =  Words[ Link[ 0 ] ].getHotSpot();
            var HotSpot_1 =  Words[ Link[ 1 ] ].getHotSpot();

            if( DEBUG ) console.log( 'hspots:', HotSpot_0, HotSpot_1, Link );

            var Path = Paper.path( "M" + HotSpot_0.x + " " + HotSpot_0.y + "L" + HotSpot_1.x + " " + HotSpot_1.y ).attr( 'stroke', '#0f0' );
            Path.toBack();
         }
      }
   };

   return that;
}

