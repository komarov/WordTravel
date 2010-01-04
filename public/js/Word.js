//Contains the description of the Word object

function createWord( Options ) {

   var that = createObject( Options );

   that.Text = Options.Text;
   that.X = 0;
   that.Y = 0;

//---private properties---
   var Paper = that.getResource( 'Paper' );
   if( Paper ) {
      var Container = Paper.rect( 0, 0).hide();
      var Content = Paper.text( 0, 0 ).hide();

      var color0 = "hsb( .0, .0, 1. )"; // white
      var color1 = "hsb( .3, 1.0, 1.0 )"; // green
      var color2 = "hsb( .0, .0, .5 )"; // gray
      Container.mouseover( function () {
            var h = 500;
            this.animate( { fill: h - 100 ? color2 : "#000", stroke: h - 100 ? color1 : "#000" }, 1000, "elastic" );
            Content.animate( { fill: h - 100 ? color1 : "#000" }, 1000, "elastic" );
            } ); 

      Container.mouseout( function () {
            var h = 500;
            this.animate( { fill: h - 100 ? "#000" : "#000", stroke: h - 100 ? color0 : "#000" }, 1000, "elastic" );
            Content.animate( { fill: h - 100 ? color0 : "#000" }, 1000, "elastic" );      
            } );

      Content.mouseover( function () {
            var h = 500;
            Container.animate( { fill: h - 100 ? color2 : "#000", stroke: h - 100 ? color1 : "#000" }, 1000, "elastic" );
            this.animate( { fill: h - 100 ? color1 : "#000" }, 1000, "elastic" );
            } ); 

      Content.mouseout( function () {
            var h = 500;
            Container.animate( { fill: h - 100 ? "#000" : "#000", stroke: h - 100 ? color0 : "#000" }, 1000, "elastic" );
            this.animate( { fill: h - 100 ? color0 : "#000" }, 1000, "elastic" );      
            } ); 

   }   

//----methods----
   that.draw = function( CornerRound ) {  
      if( Paper ) {
         var Coordinates = Paper.convertCoordinates( that );
         Content.attr( { x: Coordinates.X, y: Coordinates.Y, text: that.Text, fill: color0, font: "18px \"Dejavu Sans\"" } );
         var ContentBB = Content.getBBox();
         Container.attr( { x: ContentBB.x - 2.5 * CornerRound , y: ContentBB.y - CornerRound, width: ContentBB.width + 4 * CornerRound, height: ContentBB.height + 2 * CornerRound, r: CornerRound, fill: "#000", stroke: color0 } );

         Container.show();         
         Content.show();
      }
   };

   that.getHotSpot = function() {

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


