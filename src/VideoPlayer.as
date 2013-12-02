package  
{
	import player.Controller;
	import player.Model;
	import player.views.View;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author qngo
	 */
	 
	public class VideoPlayer extends MovieClip 
	{
		private var model : Model;
		private var view : View;
		private var controller : Controller;
		
		public function VideoPlayer()
		{
			super();
			
			model = new Model(this);
			model.addEventListener(Event.CHANGE, onModelChange);
			
			controller = new Controller(model);
			view = new View(model, controller);
			addChild(view);
		}
		
		public function init() : void
		{
			controller.transitionIn(); 
		}
		
		function ccHandler(event : Event) : void
		{
//			super.ccHandler(event);
//			model.dispatchEvent(new Event('closedCaption_changed'));
		}

		override public function stop() : void
		{
			super.stop();
		}
		
		private function onModelChange(event : Event) : void 
		{
			switch (model.sceneName)
			{
				case Model.ANIMATE_OUT_COMPLETE:
//					setTimeout(initContent, 1100); // Testing only. Must comment out for production. 
				break;
			}
			
			view.update(event);
		}
	}
}
