package com.player
{
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author qngo
	 */
	public class PlayerModel extends EventDispatcher 
	{
		public var mainTimeline : MovieClip;
		public var currentState : String;
		public var videoSrc : String = "http://www.helpexamples.com/flash/video/caption_video.flv"; 
		public var captionSrc : String = "U1L8T1C4B_1_cc.xml"; 
		public var seekBar : MovieClip;
		public var isStandAlone : Boolean;
		public var flashVars : Object;
		public var debugMode : Boolean = true;
		public var stageHeight : Number;
		public var stageWidth : Number;
		
		public var volume : Number = .7;
		
		public var debugOutput : TextField = new TextField(); 
		
		public function PlayerModel(mainTimeline : MovieClip)
		{
			this.mainTimeline = mainTimeline;
			
			if (mainTimeline.root.parent && mainTimeline.root.parent == mainTimeline.stage) 
			{
  				// Standalone
				isStandAlone = true;
				
				mainTimeline.stage.addEventListener(Event.RESIZE, onStageResize);
				
				trace(this, "Root name :: ", mainTimeline.root.name);
				
				// by querying the LoaderInfo object, set the value of paramObj to the 
				// to the value of the variable named myVariable passed from FlashVArs in the HTML
				flashVars = LoaderInfo(mainTimeline.root.loaderInfo).parameters.myVariable;
 
				// set the text of the text instance named text1. Use the toString() method
				// to convert the value from an object to a string so it can be used in the text field
			}
				stageWidth = mainTimeline.stage.stageWidth;
				stageHeight = mainTimeline.stage.stageHeight;
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
			dispatchEvent(new Event(Event.CHANGE));	
		}
	}
}
