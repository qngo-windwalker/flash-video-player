package player.components 
{
	import fl.video.FLVPlayback;
	import fl.video.MetadataEvent;
	import fl.video.VideoEvent;

	import qhn.events.AnimationEvent;

	import flash.display.MovieClip;

	/**
	 * @author qngo
	 */
	public class VideoHolder extends MovieClip 
	{
		private var playPause : MovieClip;
		private var seekBar   : QSeekBar;
		private var holderClip: MovieClip;
		
		private var player : FLVPlayback;
		
		private var marker:MovieClip;
		private var progressBar:MovieClip;
		
		private var xOffset	: Number;
		private var xMax	: Number;
		
		private var isRunning 	: Boolean;
		
		private var percent		: Number;
		private var position	: Number;
		private var duration	: uint;
		
		public function VideoHolder()
		{
			playPause = MovieClip(getChildByName("playPause_mc"));
			seekBar = QSeekBar(getChildByName("seekBar_mc"));
			holderClip = MovieClip(getChildByName("holder_mc"));
			
			player = new FLVPlayback();
			player.addEventListener(MetadataEvent.METADATA_RECEIVED, onMetadata);
			player.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onPlayerUpdate);
			player.addEventListener(VideoEvent.COMPLETE, onPlayerComplete);
			
			holderClip.addChild(player);
		}
		
		public function loadVideo(url : String) : void
		{
			player.source = url;
			isRunning = true;
		}
		
		public function transitionOut() : void
		{
			player.removeEventListener(MetadataEvent.METADATA_RECEIVED, onMetadata);
			player.removeEventListener(VideoEvent.PLAYHEAD_UPDATE, onPlayerUpdate);
			player.removeEventListener(VideoEvent.COMPLETE, onPlayerComplete);
		}
		
		public function transitionOutComplete() : void
		{
			dispatchEvent(new AnimationEvent((AnimationEvent.TRANSITION_OUT_COMPLETE)));
		}
		
		private function onMetadata(event:MetadataEvent):void
		{
			var myInfo : Object = event.info;
			duration = myInfo.duration;
			
			for (var item:String  in myInfo) 
			{
                trace(item + " = " + myInfo[item], this);
			}
			trace("|~| --------------------------- |~|");
		}
		
		private function onPlayerUpdate(event : VideoEvent) : void
		{
			trace(player.playheadPercentage);
			seekBar.updateProgress(player.playheadPercentage / 100);
			
//			progressBar.scaleX = player.playheadPercentage / 100;

//			marker.x = progressBar.x + progressBar.width;
			
//			displayTime();
		}
		
		private function onPlayerComplete(event:VideoEvent):void
		{
//			marker.x = progressBar.x;
//			marker.time_txt.text = "00:00";
			togglePlay("PAUSE");
		}
		
		private function togglePlay(str:String = null):void
		{
			if (player.playing || str == "PAUSE")
			{
				player.pause();
				playPause.gotoAndStop("PLAY");
			}
			else
			{
				player.play();
				playPause.gotoAndStop("PAUSE");
			}
			
			isRunning = !isRunning;
		}
		
		private function displayTime():void
		{
			var input : Number = Math.round(player.playheadTime);
			var time : String = (input > 3600 ? Math.floor(input/3600) + ':':'')+(input%3600 < 600 ? '0':'')+Math.floor(input%3600/60)+':'+(input%60 < 10 ? '0':'')+input%60;
			
			//marker.time_txt.text = time;
		}
	}
}
