package com.player.model
{
	import qhn.utils.Library;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
//	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.text.TextField;

	/**
	 * @author qngo
	 */
	public class PlayerModel extends EventDispatcher 
	{
		public static const TIME : String = "time";
		public var mainTimeline : MovieClip;
		public var currentState : String;
//		public var videoSrc : String = "http://www.helpexamples.com/flash/video/caption_video.flv"; 
		public var videoSrc : String = "media/howto.flv"; 
		public var captionSrc : String = "media/closed_caption.xml"; 
		public var seekBar : MovieClip;
		public var isStandAlone : Boolean;
		public var flashVars : Object;
		public var debugMode : Boolean;
		public var stageHeight : Number;
		public var stageWidth : Number;
		public var root : String; 
		public var onCompleteCallback : String = 'videoCompleted';
		public var volume : Number = .7;
		public var debugOutput : TextField = new TextField(); 
		public var controllerBarHeight : Number;
		// progressiveDownload or streaming. This dictates which View to use.
//		public var deliveryMethod : String = "progressiveDownload";		
		public var deliveryMethod : String = "streaming";
		
		private var _playbackTime : Number;
		public var hasCC : Boolean = true;

		public function PlayerModel(mainTimeline : MovieClip)
		{
			this.mainTimeline = mainTimeline;
			
			if (mainTimeline.root.parent && mainTimeline.root.parent == mainTimeline.stage) 
			{
  				// Standalone
				isStandAlone = true;
				
				mainTimeline.stage.addEventListener(Event.RESIZE, onStageResize);
				
				getFlashVars();
			}
			
			stageWidth = mainTimeline.stage.stageWidth;
			stageHeight = mainTimeline.stage.stageHeight;
				
			var vidControllBar : MovieClip = MovieClip(Library.createAsset(mainTimeline, "VideoController"));
			controllerBarHeight = vidControllBar.height;	
		}

//		public function init() : void 
//		{
//			dispatchEvent(new Event(Event.COMPLETE));
//		}

		private function getFlashVars() : void 
		{
			// by querying the LoaderInfo object, set the value of paramObj to the 
			// to the value of the variable named myVariable passed from FlashVArs in the HTML
			flashVars = LoaderInfo(mainTimeline.root.loaderInfo).parameters;
			
			debugMode = flashVars.debug;
			
			videoSrc = flashVars.vidSrc ? flashVars.vidSrc : videoSrc;
			captionSrc = flashVars.ccSrc ? flashVars.ccSrc : captionSrc;
			root = flashVars.root ? flashVars.root : root;
			onCompleteCallback = flashVars.completeCallback ? flashVars.completeCallback : onCompleteCallback;
			deliveryMethod = flashVars.deliveryMethod ? flashVars.deliveryMethod : deliveryMethod;

			// set the text of the text instance named text1. Use the toString() method
			// to convert the value from an object to a string so it can be used in the text field
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
			dispatchEvent(new Event(PlayerModel.TIME));
		}

		private function update() : void{
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
	}
}
