package com.player.views 
{
	import gs.TweenLite;

	import qhn.mvc.view.ComponentView;
	import qhn.utils.Library;

	import com.player.PlayerController;
	import com.player.model.PlayerModel;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;

	/**
	 * @author qngo
	 */
	public class UIView extends ComponentView 
	{
		private var vidControllBar : MovieClip;
		private var playPauseBtn : MovieClip;
		private var volumeBtn : MovieClip;
		private var seekBar : MovieClip;
		private var controlBarBkgd : MovieClip;
		
		private var ccBtn : MovieClip;
		
		private var fullScreen : MovieClip;

		public function UIView(aModel : PlayerModel, aController : Object = null)
		{
			super(aModel, aController);
			
			vidControllBar = MovieClip(Library.createAsset(aModel.mainTimeline, "VideoController"));
			vidControllBar.alpha = 0;
			
			ccBtn = MovieClip(vidControllBar.getChildByName("ccBtn_mc"));
			ccBtn.buttonMode = true;
			ccBtn.addEventListener(MouseEvent.CLICK, onCcClick);
			
			playPauseBtn = MovieClip(vidControllBar.getChildByName("playPause_mc"));
			playPauseBtn.mouseEnabled = true;
			playPauseBtn.buttonMode = true;
			playPauseBtn.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
//			
			volumeBtn = MovieClip(vidControllBar.getChildByName("volume_mc"));
			volumeBtn.addEventListener(MouseEvent.CLICK, volumeBtnClick);
			volumeBtn.buttonMode = true;
			
			fullScreen = MovieClip(vidControllBar.getChildByName("fullScreen_mc"));
			fullScreen.buttonMode = true;
			fullScreen.addEventListener(MouseEvent.CLICK, onFullScreenClick);
			
			controlBarBkgd = MovieClip(vidControllBar.getChildByName("controlBarBkgd_mc"));
			seekBar = MovieClip(vidControllBar.getChildByName("seekBar_mc"));
			
			aModel.seekBar = seekBar;
			aModel.addEventListener(PlayerModel.TIME, onTime);
			aModel.mainTimeline.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenRedraw);
			
			onStageResize();
			
			vidControllBar.addChild(ccBtn);
			
			addChild(vidControllBar);
		}

		private function fullScreenRedraw(event : FullScreenEvent) : void 
		{	
			onStageResize();
//			vidControllBar.y = PlayerModel(model).stageHeight - vidControllBar.height;
//			trace('PlayerModel(model).stageHeight: ' + (PlayerModel(model).stageHeight));
//			trace('fullSceenHeight', PlayerModel(model).mainTimeline.stage.fullScreenHeight);
//			vidControllBar.y = 200;
//			vidControllBar.x = 100;
//			trace('vidControllBar: ' + (vidControllBar));
		}

		override public function update(event : Event = null) : void
		{
			super.update(event);
			
			switch (PlayerModel(model).currentState)
			{
				case "transitionIn" :
					TweenLite.to(vidControllBar, .5, {autoAlpha : 1, delay: .5});
				break;
				
				case "transitionOut" :
					TweenLite.to(vidControllBar, .5, {autoAlpha : 0});
				break;
				
				case "playVideo" :
					playPauseBtn.gotoAndStop("PAUSE");
				break;
				
				case "pauseVideo" :
					playPauseBtn.gotoAndStop("PLAY");
				break;
				
				case "videoCompleted" :
					playPauseBtn.gotoAndStop("PLAY");
				break;
				
				case "closedCaptionOn" :
					ccBtn.gotoAndStop("ON");
				break;
				
				case "closedCaptionOff" :
					ccBtn.gotoAndStop("OFF");
				break;
				
				case "stageResize" :
					onStageResize();
				break;
			}
		}
		
		private function volumeBtnClick(event : MouseEvent) : void 
		{
			switch (volumeBtn.currentFrameLabel)
			{
				case "ON" : 
					volumeBtn.gotoAndStop("OFF");
					PlayerController(controller).setVolume(0);
				break;
				
				case "OFF" :
					volumeBtn.gotoAndStop("ON");
					PlayerController(controller).setVolume(.7);
				break;
			}
		}
		
		private function onPlayPauseClick(event : MouseEvent) : void 
		{
			switch (playPauseBtn.currentFrameLabel)
			{
				case "PLAY" : 
					PlayerController(controller).playVideo();
				break;
				
				case "PAUSE" :
					PlayerController(controller).pauseVideo();
				break;
			}
		}
		
		private function onCcClick(event : MouseEvent) : void 
		{
			switch (ccBtn.currentFrameLabel)
			{
				case "OFF" : 
					PlayerController(controller).enableClosedCaption();
				break;
				
				case "ON" :
					PlayerController(controller).disableClosedCaption();
				break;
			}
		}
		
		private function onTime(event : Event) : void 
		{
			var pos : Number = PlayerModel(model).playbackTime;
		}
		
		private function onFullScreenClick(event : MouseEvent) : void 
		{
			switch (fullScreen.currentFrameLabel)
			{
				case "OFF" : 
					fullScreen.gotoAndStop('ON');
					PlayerController(controller).enableFullScreen();
				break;
				
				case "ON" :
					fullScreen.gotoAndStop('OFF');
					PlayerController(controller).disableFullScreen();
				break;
			}
		}
		
		private function onStageResize(event: Event = null) : void
		{
			var rootStage : Stage = Stage(PlayerModel(model).mainTimeline.stage);
			vidControllBar.y = rootStage.stageHeight - vidControllBar.height;
			controlBarBkgd.width = rootStage.stageWidth;
			
			var padding: int = 5;
			fullScreen.x = controlBarBkgd.width - fullScreen.width - padding;
			ccBtn.x = fullScreen.x - ccBtn.width - padding;
			volumeBtn.x = ccBtn.x - volumeBtn.width; 
			seekBar.width = volumeBtn.x - seekBar.x - 26;
		}
	}
}
