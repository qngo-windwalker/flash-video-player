package com.player.views 
{
	import gs.TweenLite;

	import qhn.mvc.view.ComponentView;
	import qhn.utils.Library;

	import com.player.PlayerController;
	import com.player.PlayerModel;

	import flash.display.MovieClip;
	import flash.events.Event;
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
			
			controlBarBkgd = MovieClip(vidControllBar.getChildByName("controlBarBkgd_mc"));
			seekBar = MovieClip(vidControllBar.getChildByName("seekBar_mc"));
			
			aModel.seekBar = seekBar;
			
			onStageResize();
			
			vidControllBar.addChild(ccBtn);
			
			addChild(vidControllBar);
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
		
		private function onStageResize(event: Event = null) : void
		{
			vidControllBar.y = PlayerModel(model).stageHeight - vidControllBar.height;
			controlBarBkgd.width = PlayerModel(model).stageWidth;
			ccBtn.x = controlBarBkgd.width - ccBtn.width;
			volumeBtn.x = ccBtn.x - volumeBtn.width; 
			seekBar.width = volumeBtn.x - seekBar.x - 26;  
		}
	}
}
