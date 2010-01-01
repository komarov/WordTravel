//Contains the description of the Word object

function createWord( Options ) {

   var that = createObject( Options );

   that.Text = Options.Text;
   that.X = 0;
   that.Y = 0;

//---private properties---
   var Raphael_rect;
   var Raphael_text;

//----methods----
   that.drawWord = function( CornerRound ) {
      
      var Paper = that.getResource( 'Paper' );
      if( Paper ) {
         var Coordinates = Paper.convertCoordinates( that );
         if( DEBUG ) console.log(  Coordinates.X, Coordinates.Y, that.Text  ) ;

         Raphael_text = Paper.text( Coordinates.X, Coordinates.Y, that.Text ).attr( { fill: "#fff", font: "18px \"Dejavu Sans\"" } );

         var Raphael_textBB = Raphael_text.getBBox();
         Raphael_rect = Paper.rect( Raphael_textBB.x , Raphael_textBB.y, Raphael_textBB.width + 4 * CornerRound, Raphael_textBB.height + 2 * CornerRound, CornerRound ).attr( { fill: "#000", stroke: "#0f0" } );
         Raphael_rect.toBack();
      }
   };

   that.getHotSpot = function() {

      if( DEBUG ) console.log( 'from Word.hotSpot:', Raphael_rect );
      return Raphael_rect.getHotSpot();
   }; 

   that.setCoordinates = function( Coordinates ) {

      if( DEBUG ) console.log( Coordinates );

      that.X = Coordinates.X;
      that.Y = Coordinates.Y;
      if( DEBUG ) console.log( that.X, that.Y );    
   };

   return that;
}


