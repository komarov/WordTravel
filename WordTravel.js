//WordTravel.js
//Contains WordTravel object description

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

   this.User = user;
}

function setFrame( frame ) {

   this.Frame = frame;
}

function renderCurrentFrame() {

   this.Frame.render( this.Paper );
}

function renderFrame ( frameUID ) {

   var anotherFrame = new Frame( frameUID );
   anotherFrame.render( this.Paper );   
}

function guessWord( guess ) {

}

