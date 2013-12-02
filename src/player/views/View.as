package player.views 
{
	import gs.TweenLite;

	import player.Controller;
	import player.Model;

	import qhn.mvc.view.CompositeView;

	import flash.events.Event;

	/**
	 * @author qngo
	 */
	public class View extends CompositeView 
	{
		private var flvPlayerView : FlvPlayerView;
		//public function DropShadowFilter(distance:Num = 4.0, angle:Num = 45, color:uint = 0, alpha:Num = 1.0, blurX:Num = 4.0, blurY:Num = 4.0, strength:Num = 1.0, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false)
//		private var defaultDropShadow : DropShadowFilter = new DropShadowFilter(3, 125, 0x000000, 0.6, 7, 7, 2, 3);
		
		public function View(aModel : Model, aController : Controller = null)
		{
			super(aModel, aController);
			
			flvPlayerView = new FlvPlayerView(aModel, aController);
			add(flvPlayerView);	
			addChild(flvPlayerView);
		}
		
		public function transitionIn() : void 
		{	
			TweenLite.to(this, .2, {alpha : 1}); // For revisiting user.
		}

		public function transitionOut() : void
		{
			TweenLite.to(this,  .5,{alpha : 0, delay : .75, onComplete : (controller as Controller).transitionOutComplete()});
		}
		
		override public function update(event : Event = null) : void
		{
			super.update(event);
			
			switch ((model as Model).sceneName)
			{
				case Model.ANIMATE_IN  :
					transitionIn();
				break;
					
				case Model.ANIMATE_OUT :
					transitionOut();
				break;
			}
		}
	}
}
