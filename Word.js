//Word.js
//Contains the description of the Word object

function Word( text, links) {

   this.Text = text;
   this.X = 0;
   this.Y = 0;
   this.Links = links;

//----methods----

   this.setCoordinates = setCoordinates;
   this.drawWord = drawWord;


}

function setCoordinates( x, y ) {

   if( DEBUG ) console.log( x, y );

   this.X = x;
   this.Y = y; 
   if( DEBUG ) console.log( this.X, this.Y );
    
}

function drawWord( paper, round ) {

   if( DEBUG ) console.log(  this.X, this.Y, this.Text  ) ;
   
   var text = paper.text( this.X, this.Y, this.Text ).attr( { fill: "#fff", font: "18px \"Dejavu Sans\"" } );
  
   var textBB = text.getBBox();
   var rect = paper.rect( textBB.x , textBB.y, textBB.width + 4 * round, textBB.height + 2 * round, round ).attr( { fill: "#000", stroke: "#0f0" } );
   rect.toBack();
}


