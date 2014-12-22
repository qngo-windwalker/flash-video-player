package com.player.model
{
	import qhn.utils.Library;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.text.TextField;

	//	import flash.external.ExternalInterface;

	/**
	 * @author qngo
	 */
	public class PlayerModel extends EventDispatcher 
	{
		public static const TIME : String = "time";
		public var mainTimeline : MovieClip;
		public var currentState : String;
		public var seekBar : MovieClip;
		public var isStandAlone : Boolean;
		public var stageHeight : Number;
		public var stageWidth : Number;
		public var volume : Number = .7;
		public var debugOutput : TextField = new TextField(); 
		public var controllerBarHeight : Number;
		
		public var flashVarsObj : FlashVarsObj = new FlashVarsObj();
		
		private var _playbackTime : Number;
		public var playbackPercent : Number;

		public function PlayerModel(mainTimeline : MovieClip)
		{
			this.mainTimeline = mainTimeline;
		}

		public function init() : void 
		{
			if (mainTimeline.root.parent && mainTimeline.root.parent == mainTimeline.stage) 
			{
  				// Standalone
				isStandAlone = true;
				
				mainTimeline.stage.addEventListener(Event.RESIZE, onStageResize);
				
				flashVarsObj.getFlashVars(LoaderInfo(mainTimeline.root.loaderInfo));
			}
			
			stageWidth = mainTimeline.stage.stageWidth;
			stageHeight = mainTimeline.stage.stageHeight;
				
			var vidControllBar : MovieClip = MovieClip(Library.createAsset(mainTimeline, "VideoController"));
			controllerBarHeight = vidControllBar.height;
				
			dispatchEvent(new Event(Event.COMPLETE));
		}

		
		private function callToHTML(method : String, data : *) : void {
			if (flashVarsObj.enableExternalInterface)
			{
				if (ExternalInterface.available) {
	        		ExternalInterface.call(method, data);
				}
			}
		}
		
        	/*
        	 * 
		public function getUserAgent():String
        {
        	var userAgent : String;
            try
            {
                userAgent = ExternalInterface.call("window.navigator.userAgent.toString");
                var browser:String = "[Unknown Browser]";
     
                if (userAgent.indexOf("Safari") != -1)
                {
                    browser = "Safari";
                }
                if (userAgent.indexOf("Firefox") != -1)
                {
                    browser = "Firefox";
                }
                if (userAgent.indexOf("Chrome") != -1)
                {
                    browser = "Chrome";
                }
                if (userAgent.indexOf("MSIE") != -1)
                {
                    browser = "Internet Explorer";
                }
                if (userAgent.indexOf("Opera") != -1)
                {
                    browser = "Opera";
                }
            }
            catch (e:Error)
            {
                //could not access ExternalInterface in containing page
                return "[No ExternalInterface]";
            }
 
            return browser;
        }
        	 */

		private function onStageResize(event : Event) : void 
		{
			stageWidth = mainTimeline.stage.stageWidth;
			stageHeight = mainTimeline.stage.stageHeight;
			setState('stageResize');
		}

		public function setState(state : String) : void 
		{
			currentState = state;
			
			update();
		}
		
		public function get playbackTime() : Number{
			return _playbackTime;
		}
		
		// Only for ProgressiveDownload View
		public function set playbackTime(value : Number) : void {
			_playbackTime = value;
			trace('_playbackTime: ' + (_playbackTime));
			dispatchEvent(new Event(PlayerModel.TIME));
		}

		private function update() : void{
			
			callToHTML(flashVarsObj.onSateChange, currentState);
			
			switch (currentState){
				case "fullScreenOn" :
//					var screenRectangle:Rectangle = new Rectangle(0, 0, 200, 250); 
//            		mainTimeline.stage.fullScreenSourceRect = screenRectangle; 
					mainTimeline.stage.displayState = StageDisplayState.FULL_SCREEN;
					stageWidth = mainTimeline.stage.stageWidth;
					stageHeight = mainTimeline.stage.stageHeight;
					break;
			}
			dispatchEvent(new Event(Event.CHANGE));	
		}

		public function setPlayheadTime(playheadTime : Number, percent : Number, length : Number) : void 
		{
			var str : String = 'second=' + playheadTime + '&percent=' + percent + '&length=' + length;
			callToHTML(flashVarsObj.onPlaybackPosition, str);
		}
	}
}
