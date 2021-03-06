package com.player 
{
	import com.player.model.PlayerModel;

	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;

	/**
	 * @author qngo
	 */
	public class PlayerController 
	{
		private var model : PlayerModel;
		
		public function PlayerController(m : PlayerModel){
			model = m;
			
			// Caution with naming callback function. Might cause conflict if name too general. 
			if (model.flashVarsObj.enableExternalInterface){
				ExternalInterface.addCallback("playVideo", playVideo); 
//				ExternalInterface.addCallback("stopVideo", pause); 
				ExternalInterface.addCallback("pauseVideo", pauseVideo);
				ExternalInterface.addCallback("setVolume", setVolume);
				ExternalInterface.addCallback("gotoPercent", gotoPercent);
				ExternalInterface.addCallback("updatePlaybackTime", gotoPosition);
				ExternalInterface.addCallback("enableClosedCaption", enableClosedCaption);
			}
		}

		public function transitionIn() : void 
		{
			model.setState('transitionIn');
		}

		public function playVideo() : void 
		{
			model.setState('playVideo');
		}

		public function pauseVideo() : void 
		{
			model.setState('pauseVideo');
		}

		public function videoCompleted() : void 
		{
			model.setState("videoCompleted");
		}

		/**
		 * @param value : String so that ExternalInterface call can be used.
		 */
		public function enableClosedCaption(value : String = 'true') : void 
		{
			if (value == 'true'){
				model.showClosedCaption = true;
			} else if (value == 'false'){
				model.showClosedCaption = false;
			}
			model.setState('closedCaptionStateChange');
		}

		public function disableClosedCaption() : void 
		{
			model.showClosedCaption = false;
			model.setState('closedCaptionStateChange');
		}

		public function setVolume(number : Number) : void 
		{
			model.volume = number;
			model.setState('volumeChanged');
		}

		public function enableDebugMode() : void 
		{
			model.flashVarsObj.debugMode = true;
			model.setState('debugMode');
		}

		public function enableFullScreen() : void 
		{
			model.mainTimeline.stage.displayState = StageDisplayState.FULL_SCREEN;
			model.setState('stageResize');
		}

		public function disableFullScreen() : void 
		{
			model.mainTimeline.stage.displayState = StageDisplayState.NORMAL;
			model.setState('stageResize');
		}

		public function updatePlaybackTime(time : Number) : void 
		{
			model.playbackTime = time;
		}
		
		public function gotoPosition(percent : Number) : void{
			trace('percent: ' + (percent));
			if (percent <= 0) {
				percent = 0;
			} else if (percent >= 100 ) {
				percent = 100;
			}
			model.playbackPercent = percent;
			model.setState('positionChanged');
		}
		
		public function gotoPercent(percent : Number) : void{
			trace('percent: ' + (percent));
			if (percent <= 0) {
				percent = 0;
			} else if (percent >= 100 ) {
				percent = 100;
			}
			model.playbackPercent = percent;
			model.setState('positionChanged');
		}
	}
}
