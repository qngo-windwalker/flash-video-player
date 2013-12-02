package org.myprime.u1l8t1c4.components 
{
	import org.myprime.display.SimpleBtn;
	import flash.display.MovieClip;

	/**
	 * @author qngo
	 */
	public class QSeekBar extends MovieClip 
	{
		private var track 	: MovieClip;
		private var thumb 	: SimpleBtn;
		private var progress: MovieClip;
//		private var buffer	: MovieClip;
		
		public function QSeekBar()
		{
			track = MovieClip(getChildByName("track_mc"));
			thumb = SimpleBtn(getChildByName("thumb_mc"));
			progress = MovieClip(getChildByName("progress_mc"));
		}
		
		public function updateProgress(num : Number) : void
		{
			progress.scaleX = num;
			thumb.x = progress.width;
		}
	}
}
