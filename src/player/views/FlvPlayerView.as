package player.views 
{
	import fl.video.CaptionChangeEvent;
	import fl.video.CaptionTargetEvent;
	import fl.video.FLVPlayback;
	import fl.video.FLVPlaybackCaptioning;
	import fl.video.VideoEvent;

	import gs.TweenLite;
	import gs.plugins.AutoAlphaPlugin;
	import gs.plugins.TweenPlugin;

	import player.Controller;
	import player.Model;

	import qhn.mvc.view.ComponentView;
	import qhn.utils.Library;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**	
	 * @author qngo
	 */
	public class FlvPlayerView extends ComponentView 
	{
		private var player : FLVPlayback;
		private var caption : FLVPlaybackCaptioning;
		
		private var videoSource : String = '';
		private var vidControllBar : MovieClip;
		private var playPauseBtn : MovieClip;
		private var volumeBtn : MovieClip;
		private var seekBar : MovieClip;
		
		private var volLevel : Number = .7;

		public function FlvPlayerView(aModel : Model, aController : Controller = null)
		{
			super(aModel, aController);
			
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			this.x = 0;
			this.y = 0;
			
			vidControllBar = MovieClip(Library.createAsset(aModel.mainTimeline, "VideoController"));
			vidControllBar.x = 335;
			vidControllBar.y = 110;
			vidControllBar.alpha = 0;
			
//			player = new FLVPlayback();
			player = FLVPlayback(aModel.mainTimeline.getChildByName("flvPlayback"));
			
//			addChild(player);
			trace('player: ' + (player));
//									player.x = 335;
//			player.y = 99;
//			player.scaleX = 1.2;
//			player.skinBackgroundColor = 0x000000;
//			player.skinBackgroundAlpha = 1;
//			player.addEventListener(VideoEvent.COMPLETE, onVideoComplete);
//			player.seekBar = MovieClip(vidControllBar.getChildByName("seekbar_mc"));
			
			playPauseBtn = MovieClip(vidControllBar.getChildByName("playPause_mc"));
			playPauseBtn.mouseEnabled = false;
			playPauseBtn.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			playPauseBtn.alpha = .1; // Inactive til video has choosen.
			
			volumeBtn = MovieClip(vidControllBar.getChildByName("volume_mc"));
			volumeBtn.addEventListener(MouseEvent.CLICK, volumeBtnClick);
			volumeBtn.buttonMode = true;
			playPauseBtn.alpha = .1; // Inactive til video has choosen.

			aModel.addEventListener('closedCaption_changed', onClosedCaptionChanged);
			
			seekBar = MovieClip(vidControllBar.getChildByName("seekBar_mc"));
		}

		private function onClosedCaptionChanged(event : Event = null) : void 
		{
			
//			trace('SceneModel(model).sceneInfoObj.showCaption: ' + (SceneModel(model).sceneInfoObj.showCaption));
//			if (caption)
//			{
//				caption.showCaptions = SceneModel(model).sceneInfoObj.showCaption;
//			}
		}

		private function volumeBtnClick(event : MouseEvent) : void 
		{
			switch (volumeBtn.currentFrameLabel)
			{
				case "ON" : 
					volumeBtn.gotoAndStop("OFF");
					volLevel = 0; 
				break;
				
				case "OFF" :
					volumeBtn.gotoAndStop("ON");
					volLevel = .7; 
				break;
			}
			
//			player.volume = volLevel;
		}

		private function onVideoComplete(event : VideoEvent) : void 
		{
			// Update pause and play button.
			playPauseBtn.gotoAndStop("PLAY");
		}

		private function onPlayPauseClick(event : MouseEvent) : void 
		{
			switch (playPauseBtn.currentFrameLabel)
			{
				case "PLAY" : 
//					player.play();
					playPauseBtn.gotoAndStop("PAUSE");
				break;
				
				case "PAUSE" :
//					player.pause(); 
					playPauseBtn.gotoAndStop("PLAY");
				break;
			}
		}

		override public function update(event : Event = null) : void
		{
			super.update(event);
			
			switch (Model(model).sceneName)
			{
				case Model.ANIMATE_IN :
					addChild(vidControllBar);
					addChild(player);
					TweenLite.to(player, .2, {autoAlpha : 1});
					TweenLite.to(vidControllBar, .5, {autoAlpha : 1, delay: .5});
				break;
				
				case Model.ANIMATE_OUT :
//					if (player) player.stop();
					TweenLite.to(player, .5, {autoAlpha : 0});
					TweenLite.to(vidControllBar, .5, {autoAlpha : 0});
				break;
				
				case Model.ITEM_SELECT :
					playVideo();
				break;	
			}	
		}
		
		private function playVideo() : void 
		{
			// Just in case it wont stop the first time in the model.
//			ScenePlayer.getInstance().stop();
			
//			var item : Item = Model(model).currentSelectedItem;
//			var videoId : String = Number(item.videoSrc).toString();
//			player.source = videoSource + videoId + ".f4v";
//			player.volume = volLevel;
			
			// Update pause and play button.
			playPauseBtn.gotoAndStop("PAUSE");
			playPauseBtn.buttonMode = true;
			playPauseBtn.mouseEnabled = true;
			playPauseBtn.alpha = 1;
			
//			trace('SceneModel(model).sceneInfoObj.showCaption: ' + (Model(model)..showCaption));
//			if (caption) {
//				caption.showCaptions = false;
//				removeChild(caption);
//			}
			
			caption = new FLVPlaybackCaptioning();
			caption.flvPlayback = player;
//            caption.source = videoSource + item.captioningSrc;
			caption.showCaptions = true;
            caption.autoLayout = false;
            caption.addEventListener(Event.OPEN, onCaptionOpen);
            caption.addEventListener(Event.COMPLETE, onCaptionComplete);
            caption.addEventListener(CaptionChangeEvent.CAPTION_CHANGE, onCaptionChange);
            caption.addEventListener(CaptionTargetEvent.CAPTION_TARGET_CREATED, onCaptionTargetCreated);
			addChild(caption);
			onClosedCaptionChanged();
		}
		
		function onCaptionTargetCreated( event:CaptionTargetEvent ):void
		{
		    var tf:* = event.target.captionTarget;
		}

		private function onCaptionComplete(event : Event) : void 
		{
//			caption.showCaptions = Model(model).sceneInfoObj.showCaption;
		}

		private function onCaptionOpen(event : Event) : void 
		{
			trace('caption open');
		}

		private function onCaptionChange(e:CaptionChangeEvent):void {
//            var tf:* = e.target.captionTarget;
        }
	}
}
