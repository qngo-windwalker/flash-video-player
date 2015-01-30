package com.player.views 
{
	import fl.video.CaptionChangeEvent;
	import fl.video.CaptionTargetEvent;
	import fl.video.FLVPlayback;
	import fl.video.FLVPlaybackCaptioning;
	import fl.video.VideoAlign;
	import fl.video.VideoEvent;
	import fl.video.VideoScaleMode;

	import gs.TweenLite;
	import gs.plugins.AutoAlphaPlugin;
	import gs.plugins.TweenPlugin;

	import qhn.mvc.view.ComponentView;

	import com.player.PlayerController;
	import com.player.model.PlayerModel;

	import flash.events.Event;

	/**	
	 * @author qngo
	 */
	public class FlvPlayerView extends ComponentView 
	{
		private var player : FLVPlayback;
		private var caption : FLVPlaybackCaptioning;
		
		private var playerModel : PlayerModel;

		public function FlvPlayerView(aModel : PlayerModel, aController : PlayerController = null)
		{
			super(aModel, aController);
			
			playerModel = aModel;
			
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			player = new FLVPlayback();
//			player.isLive = aModel.deliveryMethod == 'streaming' ? true : false; // false = Progressive download
//			trace('player.isLive: ' + (player.isLive)); 
			player.skinBackgroundColor = 0x000000;
			player.skinBackgroundAlpha = 1;
			player.align = VideoAlign.CENTER;
			player.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
			player.fullScreenTakeOver = false;
//			player.scaleMode = VideoScaleMode.NO_SCALE
			player.addEventListener(VideoEvent.COMPLETE, onVideoComplete);
			player.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onPlayheadUpdate);
			
			onStageResize();
		}

		private function onPlayheadUpdate(event : VideoEvent) : void 
		{
			var playheadTime : Number = player.playheadTime;
			var percent : Number = player.playheadPercentage;
			var length : Number = player.totalTime;
			
			playerModel.setPlayheadTime(playheadTime, percent, length);
		}

		override public function update(event : Event = null) : void
		{
			super.update(event);
			
			switch (PlayerModel(model).currentState)
			{
				case "transitionIn" :
					addChild(player);
					TweenLite.to(player, .2, {autoAlpha : 1});
				break;
				
				case "transitionOut" :
					if (player) player.stop();
					TweenLite.to(player, .5, {autoAlpha : 0});
				break;
				
				case "playVideo" :
					playVideo();
					player.seekBar = PlayerModel(model).seekBar;
					checkClosedCaption();
				break;
				case "pauseVideo" :
					player.pause();
				break;
				
				case "closedCaptionStateChange" :
					checkClosedCaption();
				break;
				
				case "stageResize" :
					onStageResize();
				break;
				
				case "volumeChanged" :
					player.volume = PlayerModel(model).volume;
				break;
				
				case "positionChanged" :
//					player.playheadTime = PlayerModel(model).playback;
					player.seekPercent(PlayerModel(model).playbackPercent);
				break;
			}
		}

		private function checkClosedCaption() : void
		{
			trace('caption: ' + (caption));
			if (caption) 
			{
				caption.showCaptions = PlayerModel(model).showClosedCaption;
				trace('caption.showCaptions: ' + (caption.showCaptions));
			}
		}

		private function playVideo() : void 
		{
			var playerModel : PlayerModel = PlayerModel(model);
			
			if (!player.source){
				player.source = playerModel.flashVarsObj.videoSrc;
				player.volume = playerModel.volume;
				
				if (playerModel.flashVarsObj.captionSrc){
					addCaption();
				}
				
			} else {
				player.play();
			}
		}
		
		private function addCaption() : void {
			// A little clean up.
			if (caption) {
				caption.showCaptions = false;
				removeChild(caption);
			}
			
			caption = new FLVPlaybackCaptioning();
			caption.flvPlayback = player;
			caption.source = PlayerModel(model).flashVarsObj.captionSrc;
			caption.showCaptions = false;
            caption.autoLayout = false;
            caption.addEventListener(Event.OPEN, onCaptionOpen);
            caption.addEventListener(Event.COMPLETE, onCaptionComplete);
            caption.addEventListener(CaptionChangeEvent.CAPTION_CHANGE, onCaptionChange);
            caption.addEventListener(CaptionTargetEvent.CAPTION_TARGET_CREATED, onCaptionTargetCreated);
			addChild(caption);
		}
		
		private function onVideoComplete(event : VideoEvent) : void 
		{
			PlayerController(controller).videoCompleted();
		}

		private function onClosedCaptionChanged(event : Event = null) : void 
		{
			
		}
		
		function onCaptionTargetCreated( event:CaptionTargetEvent ):void
		{
		    var tf:* = event.target.captionTarget;
		}

		private function onCaptionComplete(event : Event) : void 
		{
			// This is important. You can only set it to false once the caption is loaded completely
			caption.showCaptions = PlayerModel(model).showClosedCaption;
		}

		private function onCaptionOpen(event : Event) : void 
		{
			trace('caption open');
		}

		private function onCaptionChange(e:CaptionChangeEvent):void {
//            var tf:* = e.target.captionTarget;
        }
        
        private function onStageResize(event: Event = null) : void
		{
			player.width = PlayerModel(model).stageWidth;
			player.height = PlayerModel(model).stageHeight - PlayerModel(model).controllerBarHeight; // minus the controlBar's height
		}
	}
}
