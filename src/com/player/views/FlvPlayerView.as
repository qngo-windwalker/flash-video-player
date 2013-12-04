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
	import com.player.PlayerModel;

	import flash.events.Event;

	/**	
	 * @author qngo
	 */
	public class FlvPlayerView extends ComponentView 
	{
		private var player : FLVPlayback;
		private var caption : FLVPlaybackCaptioning;
		

		public function FlvPlayerView(aModel : PlayerModel, aController : PlayerController = null)
		{
			super(aModel, aController);
			
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			player = new FLVPlayback();
			player.skinBackgroundColor = 0x000000;
			player.skinBackgroundAlpha = 1;
			player.align = VideoAlign.CENTER;
			player.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
//			player.scaleMode = VideoScaleMode.NO_SCALE
			player.addEventListener(VideoEvent.COMPLETE, onVideoComplete);
			
			onStageResize();
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
				break;
				case "pauseVideo" :
					player.pause();
				break;
				
				case "closedCaptionOn" :
					if (caption) {
						caption.showCaptions = true;
					}
				break;
				
				case "closedCaptionOff" :
					if (caption) {
						caption.showCaptions = false;
					}
				break;
				
				case "stageResize" :
					onStageResize();
				break;
				
				case "volumeChanged" :
					player.volume = PlayerModel(model).volume;
				break;
			}	
		}
		
		private function playVideo() : void 
		{
			if (!player.source){
				player.source = PlayerModel(model).videoSrc;
				player.volume = PlayerModel(model).volume;
				
				// A little clean up.
				if (caption) {
					caption.showCaptions = false;
					removeChild(caption);
				}
				
				caption = new FLVPlaybackCaptioning();
				caption.flvPlayback = player;
				caption.source = PlayerModel(model).captionSrc;
				caption.showCaptions = false;
	            caption.autoLayout = false;
	            caption.addEventListener(Event.OPEN, onCaptionOpen);
	            caption.addEventListener(Event.COMPLETE, onCaptionComplete);
	            caption.addEventListener(CaptionChangeEvent.CAPTION_CHANGE, onCaptionChange);
	            caption.addEventListener(CaptionTargetEvent.CAPTION_TARGET_CREATED, onCaptionTargetCreated);
				addChild(caption);
			} else {
				player.play();
			}
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
			caption.showCaptions = false;
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
			player.height = PlayerModel(model).stageHeight - 27; // minus the controlBar's height
		}
	}
}
