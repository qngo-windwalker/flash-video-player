package com.player.views 
{
	import qhn.mvc.view.ComponentView;

	import com.player.PlayerController;
	import com.player.model.ClosedCaptionHelper;
	import com.player.model.ParagraphObj;
	import com.player.model.PlayerModel;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author qngo
	 */
	public class ClosedCaptionView extends ComponentView 
	{
		private var currentParaIndex : Number;
		
		private var txtField:TextField = new TextField(  );
		private var formatter:TextFormat = new TextFormat(  );
		public var closedCaptionHelper : ClosedCaptionHelper;
        public var ccCollection : Array;
        
		public function ClosedCaptionView(aModel : PlayerModel, aController : PlayerController = null)
		{
			super(aModel, aController);
			
			aModel.addEventListener(PlayerModel.TIME, onTime);
			
			formatter.font = "Font 1";
			formatter.align = TextFormatAlign.CENTER;
			formatter.size = 14;
			formatter.color = 0xFFFFFF;
			
			txtField.background = true;
			txtField.backgroundColor = 0x000000;
//			tf.autoSize = TextFieldAutoSize.LEFT;
			txtField.width = aModel.mainTimeline.stage.stageWidth - 40;
			txtField.height = 50; 
//			txtField.border = true;
			txtField.autoSize = TextFieldAutoSize.CENTER;
         	txtField.wordWrap = true;
//			txtField.embedFonts = true;
//			txtField.condenseWhite = true;
			txtField.multiline = true;
			txtField.x = 20;
			txtField.y = aModel.mainTimeline.stage.stageHeight - aModel.controllerBarHeight - txtField.height - 40;
			txtField.visible = false;
			
			addChild(txtField);
			
			if (aModel.captionSrc)
			{
				closedCaptionHelper = new ClosedCaptionHelper();
				closedCaptionHelper.addEventListener(Event.COMPLETE, onCCLoadComplete);
				closedCaptionHelper.load(new URLRequest(aModel.captionSrc));
			} else {
				onCCLoadComplete();
			}
		}
		
		private function onCCLoadComplete(event : Event = null) : void 
		{	
			ccCollection = closedCaptionHelper.paragraphCollection;
		}
		

		override public function update(event : Event = null) : void
		{
			super.update(event);
			
//			if (ccParser.hasCC) updateCC();
//			if (PlayerModel(model).hasCC) updateCC();
			
			switch (PlayerModel(model).currentState)
			{
				case "transitionIn" :
//					addChild(player);
//					TweenLite.to(player, .2, {autoAlpha : 1});
				break;
				
				case "transitionOut" :
//					if (player) player.stop();
//					TweenLite.to(player, .5, {autoAlpha : 0});
				break;
				
				case "closedCaptionOn" :
					this.visible = true;
				break;
				
				case "closedCaptionOff" :
					this.visible = false;
				break;
				
				case "stageResize" :
					onStageResize();
				break;
				
				case "playVideo" :
				break;
				case "pauseVideo" :
				break;
			}
		}

		private function onStageResize() : void 
		{
			txtField.y = PlayerModel(model).mainTimeline.stage.stageHeight - PlayerModel(model).controllerBarHeight - txtField.height - 10;
		}

		private function onTime(event : Event) : void 
		{
			var cur : Number = -1;
			var pos : Number = PlayerModel(model).playbackTime;
			var collection : Array = closedCaptionHelper.paragraphCollection;
			var total : int = collection.length;
			for(var i : int = 0; i < total; i++){
				var pObj : ParagraphObj = collection[i];
				var begin : Number = tt2sec(pObj.begin);
				var end : Number = tt2sec(pObj.dur);
				if(begin < pos && end > pos) {
					cur = i;
					break;
				}
			}
			if(cur == -1) {
				updateCC();
			} else if(cur != currentParaIndex) {
				currentParaIndex = cur;
				updateCC(collection[cur]);
			}
//			txtField.text = String(pos);
		}
		
		private function updateCC(para : ParagraphObj = null) : void 
		{
			if(para == null) {
				txtField.text = '';
				txtField.visible = false;
			} else {
			  	txtField.htmlText = para.text;
				txtField.setTextFormat(formatter);
				txtField.visible = true;
				txtField.y = PlayerModel(model).mainTimeline.stage.stageHeight - PlayerModel(model).controllerBarHeight - txtField.height - 10;
			}
		}

		private function tt2sec(time : String) : Number {
			var hour:int = time.split(":")[0];
		    var minute:int = time.split(":")[1];
    		var secondsStr : String = time.split(":")[2];
    		var second : int = secondsStr.split('.')[0];
    		var millisecond : Number = secondsStr.split('.')[1];
    		
    		var hour2Sec : int = (hour * 60) * 60; 
    
			return hour2Sec + (minute * 60) + second  + (millisecond / 100);
		}
		
		public function SS2mmm ($SS:Number) : Number { return ($SS / 1000); }

		public function parseTime(time:String):Number {
		    var hour:int = time.split(":")[0];
		    var minute:int = time.split(":")[1];
		    return hour + minute / 60;
		}

		public function formatTime(time:Number, detailLevel:uint = 2):String {
			var HOURS:uint = 2;
			var MINUTES:uint = 1;
			var SECONDS:uint = 0;
			var intTime:uint = Math.floor(time);
			var hours:uint = Math.floor(intTime/ 3600);
			var minutes:uint = (intTime - (hours*3600))/60;
			var seconds:uint = intTime -  (hours*3600) - (minutes * 60);
			var hourString:String = detailLevel == HOURS ? hours + ":":"";
			var minuteString:String = detailLevel >= MINUTES ? ((detailLevel == HOURS && minutes <10 ? "0":"") + minutes + ":"):"";
			var secondString:String = ((seconds < 10 && (detailLevel >= MINUTES)) ? "0":"") + seconds;
			return hourString + minuteString + secondString;
		}
		
		public function toTimeCode(milliseconds:Number):String
		{
			var seconds:int = Math.floor((milliseconds/1000) % 60);
			var strSeconds:String = (seconds < 10) ? ("0" + String(seconds)):String(seconds);
			var minutes:int = Math.round(Math.floor((milliseconds/1000)/60));
			var strMinutes:String = (minutes < 10) ? ("0" + String(minutes)):String(minutes);
			var strMilliseconds:String = milliseconds.toString();
			strMilliseconds = strMilliseconds.slice(strMilliseconds.length -3, strMilliseconds.length)
			var timeCode:String = strMinutes + ":" + strSeconds + ':' + strMilliseconds;
			return timeCode;
		}
	}
}
