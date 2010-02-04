//Base class implementation

function createObject( Options ) {

   var that = {};
   var Context = Options.Context;

   that.getContext = function() {
      return Context;
   };

   that.getResource = function( ResourceName ) {
      var Context = that.getContext();
      return that[ ResourceName ] || Context && Context.getResource( ResourceName );
   };

   return that;
}
