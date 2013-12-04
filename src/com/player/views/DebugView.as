package com.player.views 
{
	import qhn.mvc.view.ComponentView;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author qngo
	 */
	public class DebugView extends ComponentView 
	{
		var debugText : TextField;
		private var tf : TextField = new TextField();       // create a TextField names tf

		public function DebugView(aModel : Object, aController : Object = null)
		{
			super(aModel, aController);
			
			 debugText = aModel.debugOutput;
			debugText.addEventListener(Event.CHANGE, onTextChange);
			
			tf.background = true;
			tf.backgroundColor = 0xFFFFFF;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.border = true;
			addChild(tf);                             // add the TextField to the DisplayList so that it appears on the Stage

			tf.appendText("params:" + "\n");
			try
			{
				var keyStr : String;
				var valueStr : String;
				var paramObj : Object = aModel.flashVars;
				for (keyStr in paramObj) 
				{
					valueStr = String(paramObj[keyStr]);
					tf.appendText("\t" + keyStr + ":\t" + valueStr + "\n");  // add each variable name and value to the TextField named tf
				}
			} 
			catch (error : Error) 
			{
				tf.appendText(error.toString());
			}
		}

		private function onTextChange(event : Event) : void 
		{
			tf.appendText(debugText.text);
		}

		override public function update(event : Event = null) : void
		{
			super.update(event);
			
			switch (model.currentState)
			{	
				case "videoCompleted" :
					tf.appendText("video completed" + "\n");
				break;
			}
				
		}
	}
}
