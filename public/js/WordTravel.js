//Contains WordTravel object description

function createWordTravel( Options ) {

   var that = createObject( Options );

   that.YUI = Options.YUI;
   that.Paper = Options.Paper;
   that.Paper.convertCoordinates = function( Coordinates ) {
      var Width = that.Paper.width;
      var Height = that.Paper.height;

      var XStep = Width / 100;
      var YStep = Height / 100;

      return { X: Width / 2 + XStep * Coordinates.X, Y: Height / 2 - YStep * Coordinates.Y };
   };

//----methods----

   that.run = function() {
      that.onGuessWordSuccess = that.renderCurrentFrame;
      that.onGuessWordFail = function() { alert( 'try again' ) };

      that.getFrameList( function( FrameList ) {
         var ChosenFrameUid;
         for( var FrameUid in FrameList ) {
            if( FrameList.hasOwnProperty( FrameUid ) ) {
               ChosenFrameUid = FrameUid;
               break;
            }
         }
         that.setFrame( createFrame( { UID: ChosenFrameUid, Context: that } ) );
         that.renderCurrentFrame();
      } );  
   };


   that.setFrame = function( Frame ) {

      that.Frame = Frame;
   };

   that.renderCurrentFrame = function() {

      that.Frame.render();
   };

   that.getFrameList = function( Callback ) {
      var RequestConfig = {
         method: 'GET',
         on: {
            success: function( transactionid, request ) {
               Callback && Callback( that.YUI.JSON.parse( request.responseText ) );
            }
         }
      };
      that.YUI.io( '/Frame/List', RequestConfig );
   };

   that.guessWordInFrame = function( Guess ) {
      var RequestConfig = {
         method: 'POST',
         on: {
            success: function( transactionid, request ) {
               var GuessResult = request.responseText;
               if( GuessResult ) {
                  that.onGuessWordSuccess && that.onGuessWordSuccess();
               }
               else {
                  that.onGuessWordFail && that.onGuessWordFail();
               }
            }
         },
         data: 'Guess=' + Guess 
      };
      var FrameUID = that.Frame.UID;
      that.YUI.io( '/Frame/' + FrameUID + '/Guess', RequestConfig );
   }; 

   return that;
}

