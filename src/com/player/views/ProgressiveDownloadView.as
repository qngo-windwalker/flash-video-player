package com.player.views 
{
	import gs.plugins.AutoAlphaPlugin;
	import gs.plugins.TweenPlugin;

	import qhn.mvc.view.ComponentView;

	import com.player.PlayerController;
	import com.player.model.ClosedCaptionHelper;
	import com.player.model.PlayerModel;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;

	/**
	 * @author qngo
	 * This custome player allows playing video on local machine without 
	 * modifing Flash global security setting.
	 * The main item is setting the NetConnection to connect(null) 
	 */
	public class ProgressiveDownloadView extends ComponentView 
	{
		//		private var videoURL:String = "http://www.helpexamples.com/flash/video/cuepoints.flv";
		private var videoURL:String;
        private var connection:NetConnection;
        private var stream:NetStream;
        private var video:Video = new Video();  
        
        public function ProgressiveDownloadView(aModel : PlayerModel, aController : PlayerController = null)
		{
			super(aModel, aController);
			
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			videoURL = aModel.videoSrc;
			
			aModel.mainTimeline.stage.addEventListener(Event.RESIZE, onStageResize);
			
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);
		}
	
		override public function update(event : Event = null) : void
		{
			super.update(event);
			
			switch (PlayerModel(model).currentState)
			{
				case "transitionIn" :
//					addChild(player);
//					TweenLite.to(player, .2, {autoAlpha : 1});
				break;
				
				case "transitionOut" :
//					if (player) player.stop();
//					TweenLite.to(player, .5, {autoAlpha : 0});
				break;
				
				case "playVideo" :
//					stream.seek(20);
					stream.resume();
//					player.seekBar = PlayerModel(model).seekBar;
				break;
				case "pauseVideo" :
					stream.pause();
				break;
			
				case "volumeChanged" :
					var soundTran : SoundTransform = new SoundTransform(PlayerModel(model).volume, 0);
					stream.soundTransform = soundTran;
//					player.volume = PlayerModel(model).volume;
				break;
			}
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + videoURL);
                    break;
                case "NetStream.Play.Start":
                	onStageResize();
                	break;
                case "NetStream.Buffer.Full":
                	// Load completed
                	break;
                case "NetStream.Unpause.Notify":
    	            addEventListener(Event.ENTER_FRAME, onEnterFrame);
                	break;
                case "NetStream.Pause.Notify":
                	removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                	break;
			}
			trace('event.info.code: ' + (event.info.code));
		}

		private function onEnterFrame(event : Event) : void 
		{
			PlayerController(controller).updatePlaybackTime(stream.time);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

        private function connectStream():void {
            addChild(video);
            stream = new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler); 
            stream.client = new CustomClient();
            video.attachNetStream(stream);
            stream.play(videoURL);
            stream.pause(); // Preloading technique
        }
        
        function asyncErrorHandler(event:AsyncErrorEvent):void 
		{ 
		    // ignore error
		}
		
		private function onStageResize(event: Event = null) : void
		{
			var pModel : PlayerModel = PlayerModel(model);
			var availHeight : int = pModel.mainTimeline.stage.stageHeight - pModel.controllerBarHeight;
			
			if(video.videoWidth > 0 && video.width != video.videoWidth){
		        video.width = video.videoWidth;
		        video.height = video.videoHeight;
		        
			    var proportions: Number = video.width / video.height;
				scaleProportionalByWidth(pModel.mainTimeline.stage.stageWidth);
				
				// Center stage
				video.x = (pModel.stageWidth - video.width) / 2;
				
		        // If there's room, center the video vertically
		        if (availHeight > video.height){
		        	video.y = (availHeight - video.height) / 2;
		        } else {
		        	video.y = 0;
		        }
		        
//				scaleProportionalByHeight(pModel.stageHeight - pModel.controllerBarHeight);
		    }
		    
		    function scaleProportionalByWidth ( newWidth:Number ) : void {
			    video.width = newWidth;
			    video.height = newWidth / proportions;
			}
			
			function scaleProportionalByHeight ( newHeight : Number ) : void {
			    video.height = newHeight;
			    video.width = newHeight * proportions;
			}
		}
	}
}
class CustomClient {
    public function onMetaData(info:Object):void {
        trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }
    public function onCuePoint(info:Object):void {
        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }
}