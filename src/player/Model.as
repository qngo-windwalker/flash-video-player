package player 
{
	import flash.display.MovieClip;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author qngo
	 */
	public class Model extends EventDispatcher 
	{
		public static const ANIMATE_IN 			: String = "animateIn";
		public static const ANIMATE_IN_COMPLETE	: String = "animateInComplete";
		public static const ANIMATE_OUT 		: String = "animateOut";
		public static const ANIMATE_OUT_COMPLETE : String = "animateOutComplete";
		public static const ITEM_SELECT		: String = "itemSelect";
		
				
		public var items : Array;
		public var mainTimeline: MovieClip;
		
		private var _totalItem : int;
		private var _index : int = 0;
		private var _sceneName : String;
		
		private var labels : Array = [
					"Don't drink alone",	
					"Don't drink in the morning",
					"Take a cold shower",
					"Friends don't let friends drive drunk",
					"Avoid hard liquor, stick with beer and wine"
					];
									
		private var interactionGroups : Array = [
					"play_dont_drink_alone",
					"play_dont_drink_morning",
					"play_take_cold_shower",
					"play_friends_dont_let_friends_drive_drunk",
					"play_avoid_hard_liquor"
					];
			
		private var brightcoveVideoCollection : Array = [
					818961190001,
					818961489001,
					818961486001,
					818961488001,
					818961189001
					];
					
		private var captioningCollection : Array = [
					'U1L8T1C4B_1_cc.xml',
					'U1L8T1C4B_2_cc.xml',
					'U1L8T1C4B_5_cc.xml',
					'U1L8T1C4B_4_cc.xml',
					'U1L8T1C4B_3_cc.xml'
					];

		public function Model(mainTimeline : MovieClip)
		{
			
			this.mainTimeline = mainTimeline;
		}

		public function gotoScene(scene : String) : void
		{
			_sceneName = scene;
			
			update();
		}

		public function setItemSelected(item : Object) : void 
		{
//			if (currentSelectedItem) currentSelectedItem.activated = true; 
//			
//			currentSelectedItem = item; 
//			currentSelectedItem.activated = false;
			
//			var interaction : String = interactionGroups[currentSelectedItem.id];
//			
//			dispatchEvent(new AssetInteractionEvent(new AssetInteraction("", "", interaction)) );
//			
			_sceneName = ITEM_SELECT;

			update();
		}
		
//		public function get currentItem() : ItemObject { return items[index]; }
		public function get totalItem() : int { return _totalItem; }
		public function get sceneName() : String { return _sceneName; }
		
		public function get index() 	: int { return _index; }
		public function set index(value : int) : void
		{
			_index = value;
			update();
		}

		private function update() : void 
		{
			switch (_sceneName)
			{
				case ANIMATE_IN_COMPLETE :
//					scenePlayer.play();
				break;
				
				case ITEM_SELECT :
//					scenePlayer.stop();
//					trace('scenePlayer: ' + (scenePlayer));
					break;
				
				case ANIMATE_OUT :
//					scenePlayer.stop();
				break;
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
