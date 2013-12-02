package qhn.utils 
{
	import flash.external.ExternalInterface;

	/**
	 * @author qngo
	 */
	public class DrupalTrace 
	{
		public static function write(data : *) : void
		{
			ExternalInterface.call("trace", data);
		}
	}
}
