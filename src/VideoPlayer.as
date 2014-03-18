package  
{
	import ru.kozlovskij.external.ExternalInterfaceExtended;

	import com.player.PlayerController;
	import com.player.PlayerModel;
	import com.player.views.PlayerView;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Timer;

	public class VideoPlayer extends MovieClip 
	{
		private var model : PlayerModel;
		private var controller : PlayerController;
		private var view : PlayerView;

		public function VideoPlayer()
		{
//			Security.showSettings(SecurityPanel.SETTINGS_MANAGER );
//			Security.loadPolicyFile("xmlsocket://foo.com:414");
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
//			Security.loadPolicyFile("crossdomain.xml"); // This will use http to request the file. 
			
// 			ExternalInterface.addCallback("sendToActionScript", receivedFromJavaScript);
 			ExternalInterfaceExtended.addCallback("sendToActionScript", receivedFromJavaScript);
 			
 			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
 			
			model = new PlayerModel(this);
			model.addEventListener(Event.CHANGE, onModelChange);
			
            controller = new PlayerController(model);
			view = new PlayerView(model, controller);
			addChild(view);
			
			init(); 
		}
		
		public function init() : void
		{
			controller.transitionIn();
		}
		
		private function onModelChange(event : Event) : void 
		{
			switch (PlayerModel(model).currentState)
			{	
				case "videoCompleted" :
				if (ExternalInterface.available) {
                	ExternalInterface.call(model.onCompleteCallback, model.videoSrc);
					}
				break;
			}
				
			view.update(event);
		}
		
		private function toHtml() : void
		{
			if (ExternalInterface.available) {
                try {
					model.debugOutput.appendText("Adding callback...\n");
                    ExternalInterface.addCallback("sendToActionScript", receivedFromJavaScript);
                    if (checkJavaScriptReady()) {
                        model.debugOutput.appendText("JavaScript is ready.\n");
                    } else {
                        model.debugOutput.appendText("JavaScript is not ready, creating timer.\n");
                        var readyTimer:Timer = new Timer(100, 0);
                        readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
                        readyTimer.start();
                    }
                } catch (error:SecurityError) {
                    model.debugOutput.appendText("A SecurityError occurred: " + error.message + "\n");
                } catch (error:Error) {
                    model.debugOutput.appendText("An Error occurred: " + error.message + "\n");
                }
            } else {
                model.debugOutput.appendText("External interface is not available for this container.");
            }
		}
		
		private function receivedFromJavaScript(value:String):void {
            model.debugOutput.appendText("JavaScript says: " + value + "\n");
            if (value == "debug")
			{
				controller.enableDebugMode();
			}
		}
        private function checkJavaScriptReady():Boolean {
            var isReady:Boolean = ExternalInterface.call("isReady");
            return isReady;
        }
        private function timerHandler(event:TimerEvent):void {
            model.debugOutput.appendText("Checking JavaScript status...\n");
            var isReady:Boolean = checkJavaScriptReady();
            if (isReady) {
                model.debugOutput.appendText("JavaScript is ready.\n");
                Timer(event.target).stop();
            }
        }
       
	}
}
