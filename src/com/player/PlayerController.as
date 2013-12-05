package com.player 
{

	/**
	 * @author qngo
	 */
	public class PlayerController 
	{
		private var model : PlayerModel;
		
		public function PlayerController(m : PlayerModel){
			model = m;
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

		public function enableClosedCaption() : void 
		{
			model.setState('closedCaptionOn');
		}

		public function disableClosedCaption() : void 
		{
			model.setState('closedCaptionOff');
		}

		public function setVolume(number : Number) : void 
		{
			model.volume = number;
			model.setState('volumeChanged');
		}

		public function enableDebugMode() : void 
		{
			model.debugMode = true;
			model.setState('debugMode');
		}
	}
}
