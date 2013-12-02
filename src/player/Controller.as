package player 
{
	/**
	 * @author qngo
	 */
	public class Controller
	{
		private var model : Model;
		
		public function Controller(m : Model)
		{
			model = m;	
		}

		public function next() : void
		{
			model.index ++;	
		}
		
		public function previous() : void
		{
			model.index --;	
		}

		public function transitionIn() : void 
		{
			model.gotoScene(Model.ANIMATE_IN);
		}
		
		public function transitionInComplete() : void 
		{
			model.gotoScene(Model.ANIMATE_IN_COMPLETE);
		}
		
		public function transitionOut() : void 
		{
			model.gotoScene(Model.ANIMATE_OUT);
		}
		
		public function transitionOutComplete() : void
		{
			model.gotoScene(Model.ANIMATE_OUT_COMPLETE);
		}
	}
}
