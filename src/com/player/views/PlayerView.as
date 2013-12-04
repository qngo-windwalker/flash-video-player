package com.player.views 
{
	import com.player.PlayerModel;
	import com.player.PlayerController;
	import qhn.mvc.view.CompositeView;

	import flash.events.Event;

	/**
	 * @author qngo
	 */
	public class PlayerView extends CompositeView 
	{
		private var flvPlayerView : FlvPlayerView;
		private var uiView : UIView;
		//public function DropShadowFilter(distance:Num = 4.0, angle:Num = 45, color:uint = 0, alpha:Num = 1.0, blurX:Num = 4.0, blurY:Num = 4.0, strength:Num = 1.0, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false)
//		private var defaultDropShadow : DropShadowFilter = new DropShadowFilter(3, 125, 0x000000, 0.6, 7, 7, 2, 3);
		
		public function PlayerView(aModel : PlayerModel, aController : PlayerController = null)
		{
			super(aModel, aController);
			
			flvPlayerView = new FlvPlayerView(aModel, aController);
			
			uiView = new UIView(aModel, aController);
			
			add(uiView);
			add(flvPlayerView);	
				
			addChild(uiView);
			addChild(flvPlayerView);
			
			if (aModel.debugMode){
				var debugView = new DebugView(aModel, aController);
				add(debugView);
				addChild(debugView);
			}
		}
				
		override public function update(event : Event = null) : void
		{
			super.update(event);
		}
	}
}
