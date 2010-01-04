//Contains the description of the Frame object


function createFrame( Options ) {
   
   var that = createObject( Options );
   that.UID = Options.UID;

   var Paper = that.getResource( 'Paper' );
   var LocalYUI = that.getResource( 'YUI' );
   var LinkPaths = [];
   var Words = {};

   that.render = function() {
      var RequestConfig = {
         method: 'GET',
         on: {
            success: function( transactionid, request ) {
               purgeLinkPaths();
               purgeWords();
               render( LocalYUI.JSON.parse( request.responseText ) );
            }
         }
      };
      LocalYUI.io( '/Frame/' + that.UID, RequestConfig );


      function purgeLinkPaths() {
         for( var Index in LinkPaths ) {
            if( LinkPaths.hasOwnProperty( Index ) ) {
               LinkPaths[ Index ].remove();
            }
         }
         LinkPaths = [];
      }


      function purgeWords() {
         for( var WordUID in Words ) {
            if( Words.hasOwnProperty( WordUID ) ) {
               Words[ WordUID ].remove();
            }
         }
         Words = {};
      }


      function render( FrameData ) {
         var CornerRound = 3;
         var WordsData = FrameData.Words;
         var LinksData = FrameData.Links;
         for( var WordUID in WordsData ) {
            if( WordsData.hasOwnProperty( WordUID ) ) {
               Words[ WordUID ] = createWord( { Text: WordsData[ WordUID ], Context: that } );
               Words[ WordUID ].setCoordinates( FrameData.Coordinates[ WordUID ] );   
               Words[ WordUID ].draw( CornerRound );      
               if( DEBUG ) console.log( Words[ WordUID ] );
            }
         }

         for( var index in LinksData ) {
            if( LinksData.hasOwnProperty( index ) ) {
               var Link = LinksData[ index ];

               if( !DEBUG ) console.log( Link );
               var HotSpot_0 =  Words[ Link[ 0 ] ].getHotSpot();
               var HotSpot_1 =  Words[ Link[ 1 ] ].getHotSpot();


               var LinkPath = Paper.path( "M" + HotSpot_0.x + " " + HotSpot_0.y + "L" + HotSpot_1.x + " " + HotSpot_1.y ).attr( 'stroke', '#fff' );
               LinkPath.toBack();
               LinkPaths.push( LinkPath );
            }
         }
      }
   };

   return that;
}

