//Contains the description of the Word object

function createWord( Options ) {

   var that = createObject( Options );

   that.Text = Options.Text;
   that.X = 0;
   that.Y = 0;

//---private properties---
   var Container;
   var Content;

//----methods----
   that.draw = function( CornerRound ) {
      
      var Paper = that.getResource( 'Paper' );
      if( Paper ) {
         var Coordinates = Paper.convertCoordinates( that );
         if( DEBUG ) console.log(  Coordinates.X, Coordinates.Y, that.Text  ) ;

         Content = Paper.text( Coordinates.X, Coordinates.Y, that.Text ).attr( { fill: "#fff", font: "18px \"Dejavu Sans\"" } );

         var ContentBB = Content.getBBox();
         Container = Paper.rect( ContentBB.x , ContentBB.y, ContentBB.width + 4 * CornerRound, ContentBB.height + 2 * CornerRound, CornerRound ).attr( { fill: "#000", stroke: "#0f0" } );
         Container.toBack();
      }
   };

   that.getHotSpot = function() {

      if( DEBUG ) console.log( 'from Word.hotSpot:', Container );
      return Container.getHotSpot();
   }; 

   that.setCoordinates = function( Coordinates ) {

      if( DEBUG ) console.log( Coordinates );

      that.X = Coordinates.X;
      that.Y = Coordinates.Y;
      if( DEBUG ) console.log( that.X, that.Y );    
   };

   that.remove = function() {
      Container.remove();
      Content.remove();
   };

   return that;
}


