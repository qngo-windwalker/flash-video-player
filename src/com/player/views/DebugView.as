package com.player.views 
{
	import qhn.mvc.view.ComponentView;

	import com.player.PlayerModel;

	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author qngo
	 */
	public class DebugView extends ComponentView 
	{
		var debugText : TextField;
		private var tf : TextField = new TextField();       // create a TextField names tf
		private var pModel : PlayerModel;

		public function DebugView(aModel : PlayerModel, aController : Object = null)
		{
			super(aModel, aController);
			
			pModel = aModel;
			
			debugText = aModel.debugOutput;
			debugText.addEventListener(Event.CHANGE, onTextChange);
			
			tf.background = true;
			tf.backgroundColor = 0xFFFFFF;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.border = true;
			addChild(tf);                             // add the TextField to the DisplayList so that it appears on the Stage
		}

		private function onTextChange(event : Event) : void 
		{
			tf.appendText(debugText.text);
		}

		override public function update(event : Event = null) : void
		{
			super.update(event);
			
			switch (pModel.currentState)
			{	
				case "videoCompleted" :
					tf.appendText("video completed" + "\n");
				break;
			}
			
			tf.appendText("isStandAlone:" + pModel.isStandAlone +"\n");
			tf.appendText("videoSrc:" + pModel.videoSrc + "\n");
			tf.appendText("CC:" + pModel.captionSrc + "\n");
			tf.appendText("params:" + "\n");
			
			try
			{
				var keyStr : String;
				var valueStr : String;
				var paramObj : Object = pModel.flashVars;
				
				for (keyStr in paramObj) 
				{
					valueStr = String(paramObj[keyStr]);
					ExternalInterface.call("sendToJavaScript", keyStr);
					tf.appendText("\t" + keyStr + ":\t" + valueStr + "\n");  // add each variable name and value to the TextField named tf
				}
			} 
			catch (error : Error) 
			{
				tf.appendText(error.toString());
			}
				
		}
	}
}
