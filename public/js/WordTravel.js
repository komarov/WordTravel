//Contains WordTravel object description

function createWordTravel( Options ) {

   var that = createObject( Options );

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
      
      that.Frame = createFrame( { UID: 'dfhgkljhlkj', Context: that } );
      if( DEBUG ) console.log( that );
      that.renderCurrentFrame();
   };

   that.login = function() {
   };


   that.setUser = function( User ) {

      that.User = User;
   };

   that.setFrame = function( Frame ) {

      that.Frame = Frame;
   };

   that.renderCurrentFrame = function() {

      that.Frame.render();
   };

   that.FrameByUID = function( FrameUID ) {

      var FrameData = getFrameData( FrameUID );
      if( DEBUG ) console.log( FrameData );

      for( var wordUID in FrameData.Words ) {
         if( FrameData.Words.hasOwnProperty( wordUID ) ) {
            that.Words[ wordUID ] = new Word( FrameData.Words[ wordUID ] );
            if( DEBUG ) console.log( that.Words[ wordUID ] );
         }
      }

      that.Links = Frame.Links;
   };

   return that;
}

