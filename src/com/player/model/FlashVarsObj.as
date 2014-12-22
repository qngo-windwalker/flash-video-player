package com.player.model 
{
	import flash.display.LoaderInfo;

	/**
	 * @author qngo
	 */
	public class FlashVarsObj 
	{
		public var flashVars : Object;
		public var debugMode : Boolean;
		public var root : String; 
		public var controlBarVisible : Boolean = true;
		public var enableExternalInterface : Boolean = false;
		//		public var videoSrc : String = "http://www.helpexamples.com/flash/video/caption_video.flv"; 
		public var videoSrc : String = "media/howto.flv"; 
//		public var captionSrc : String = "media/closed_caption.xml"; 
		public var captionSrc : String; 
		// progressiveDownload or streaming. This dictates which View to use.
//		public var deliveryMethod : String = "progressiveDownload";		
		public var deliveryMethod : String = "streaming";
		public var onCompleteCallback : String = 'videoCompleted';
		public var onSateChange : String = 'onSateChange';
		public var onPlaybackPosition : String = 'onPlaybackPosition';
		
		public function getFlashVars(loaderInfo : LoaderInfo) : void 
		{
			flashVars = loaderInfo.parameters;
			
			debugMode = flashVars.debug;
			videoSrc = flashVars.vidSrc ? flashVars.vidSrc : videoSrc;
			captionSrc = flashVars.ccSrc ? flashVars.ccSrc : captionSrc;
			root = flashVars.root ? flashVars.root : root;
			onPlaybackPosition = flashVars.onPlaybackPosition ? flashVars.onPlaybackPosition : onPlaybackPosition;
			onCompleteCallback = flashVars.completeCallback ? flashVars.completeCallback : onCompleteCallback;
			deliveryMethod = flashVars.deliveryMethod ? flashVars.deliveryMethod : deliveryMethod;
			enableExternalInterface = flashVars.enableExternalInterface == 'true' ? flashVars.enableExternalInterface : enableExternalInterface;
			controlBarVisible = flashVars.controlBarVisible == 'false' ? false : controlBarVisible;
		}
	}
}
