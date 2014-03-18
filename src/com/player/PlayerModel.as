package com.player
{
	import qhn.utils.Library;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author qngo
	 */
	public class PlayerModel extends EventDispatcher 
	{
		public var mainTimeline : MovieClip;
		public var currentState : String;
		public var videoSrc : String = "http://www.helpexamples.com/flash/video/caption_video.flv"; 
		public var captionSrc : String; 
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

			// set the text of the text instance named text1. Use the toString() method
			// to convert the value from an object to a string so it can be used in the text field
		}

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
