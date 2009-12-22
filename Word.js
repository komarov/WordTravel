//Word.js
//Contains the description of the Word object

function Word( text ) {

   this.Text = text;
   this.X = 0;
   this.Y = 0;

//---private properties---
   var Raphael_rect;
   var Raphael_text;

//----methods----
   this.setCoordinates = setCoordinates;
   this.drawWord = function drawWord( paper, round ) {

      if( DEBUG ) console.log(  this.X, this.Y, this.Text  ) ;

      Raphael_text = paper.text( this.X, this.Y, this.Text ).attr( { fill: "#fff", font: "18px \"Dejavu Sans\"" } );

      var Raphael_textBB = Raphael_text.getBBox();
      Raphael_rect = paper.rect( Raphael_textBB.x , Raphael_textBB.y, Raphael_textBB.width + 4 * round, Raphael_textBB.height + 2 * round, round ).attr( { fill: "#000", stroke: "#0f0" } );
      Raphael_rect.toBack();

      Raphael_rect.node.onclick = function() { 
         if( Raphael_rect.attrs.fill == "#000" ) {
            Raphael_rect.attr( { fill: "#f00" } ); 
            var textarea = document.createElement( 'INPUT' ); 
            document.body.appendChild( textarea );
         }
         else {
            Raphael_rect.attr( { fill: "#000" } );            
            var tareas = document.body.getElementsByTagName( 'INPUT' );
            if( DEBUG ) console.log( document, tareas );
            for( var index in tareas ) {
               document.body.removeChild( tareas[ index ] );
            }
         }
      };
   };

   this.hotSpot = function hotSpot() {

      if( DEBUG ) console.log( 'from Word.hotSpot:', Raphael_rect );
      return Raphael_rect.getHotSpot();

   }
}

function setCoordinates( x, y ) {

   if( DEBUG ) console.log( x, y );

   this.X = x;
   this.Y = y; 
   if( DEBUG ) console.log( this.X, this.Y );    
}
