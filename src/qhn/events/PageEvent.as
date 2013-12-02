package qhn.events 
{
	import flash.events.Event;

	/**
	 * @author qngo
	 */
	public class PageEvent extends Event 
	{
		public static const PAGE_COMPLETE = "pageComplete";
		public static const PAGE_END = "pageEnd";
		
		public function PageEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
