/*function include(url) {

  var script = document.createElement('script');
  script.setAttribute('type', 'text/javascript')
  script.setAttribute('src', url);
  document.getElementsByTagName('head').item(0).appendChild(script);
}

include( "raphael-min.js" );
include( "Frame.js" );
*/

function WordTravel( paper ) {

   this.PaperWidth = 800;
   this.PaperHeight = 600;
   this.Paper = paper;
   this.Frame = NaN;
   
//----methods----
   this.setUser = setUser;
   this.setFrame = setFrame;
   this.renderCurrentFrame = renderCurrentFrame; 
   this.renderFrame = renderFrame;
   this.guessWord = guessWord;

} 

function setUser( user ) {

   this.user = user;
}

function setFrame( frame ) {

   this.frame = frame;
}

function renderCurrentFrame() {

   this.Frame.render( this.Paper );
}

function renderFrame ( frameUID ) {

   this.Frame = new Frame( frameUID );
   this.Frame.render( this.Paper );   
}

function guessWord( guess ) {

}

