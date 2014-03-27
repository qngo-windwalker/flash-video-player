package com.player.views 
{
	import qhn.mvc.view.ComponentView;
	import com.player.model.PlayerModel;
	import com.player.PlayerController;
	import qhn.mvc.view.CompositeView;

	import flash.events.Event;

	/**
	 * @author qngo
	 */
	public class PlayerView extends CompositeView 
	{
		private var videoView : ComponentView;
		private var uiView : UIView;
		private var debugView : DebugView;
		private var ccView : ClosedCaptionView;

		//public function DropShadowFilter(distance:Num = 4.0, angle:Num = 45, color:uint = 0, alpha:Num = 1.0, blurX:Num = 4.0, blurY:Num = 4.0, strength:Num = 1.0, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false)
//		private var defaultDropShadow : DropShadowFilter = new DropShadowFilter(3, 125, 0x000000, 0.6, 7, 7, 2, 3);
		
		public function PlayerView(aModel : PlayerModel, aController : PlayerController = null)
		{
			super(aModel, aController);
			
			videoView = aModel.deliveryMethod == "progressiveDownload" ? new ProgressiveDownloadView(aModel, aController) : new FlvPlayerView(aModel, aController);
			debugView = new DebugView(aModel, aController);
			uiView = new UIView(aModel, aController);
			
			add(uiView);
			add(videoView);	
			add(debugView);
			
			addChild(videoView);
			addChild(uiView);
			
//			ccView = new ClosedCaptionView(aModel, aController);
//			add(ccView);
//			addChild(ccView);
		}

		override public function update(event : Event = null) : void
		{
			super.update(event);
			
			if (PlayerModel(model).debugMode)
			{
				addChild(debugView);
			} else {
				if (debugView.parent){
					removeChild(debugView);
				}
			}
		}
	}
}
