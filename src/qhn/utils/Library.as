package qhn.utils 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.text.Font;

	/**
	 * @author qngo
	 */
	public class Library 
	{
		/**
		 * Create a new class from the library.
		 * 
		 * @param mc : MovieClip - The document class or swf that contains the class.
		 * @param className : String - The class name in the library.
		 * 
		 * @example  var myMov : MovieClip = MovieClip(Library.createAsset(this, "MyMovieClass"));
		 */
		public static function createAsset(mc : MovieClip, className : String) :  DisplayObject
		{
			var c : Class = Class(mc.loaderInfo.applicationDomain.getDefinition(className));
			return new c();
		}

		public static function createSound(mc : MovieClip, className : String) : Sound
		{
			var c : Class = Class(mc.loaderInfo.applicationDomain.getDefinition(className));
			return new c();			
		}
		
		public static function createFont(mc : MovieClip, className : String) : Font
		{
			var c : Class = Class(mc.loaderInfo.applicationDomain.getDefinition(className));
			return new c();			
		}
	}
}
