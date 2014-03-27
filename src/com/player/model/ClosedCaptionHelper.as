package com.player.model 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author qngo
	 */
	public class ClosedCaptionHelper extends EventDispatcher 
	{
		private var _hasCC : Boolean = false;
		private var urlLoader : URLLoader;
		public var paragraphCollection : Array = [];
		
		public function ClosedCaptionHelper()
		{
		}
		
		public function load(urlReq: URLRequest) : void
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);
//			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			urlLoader.load(urlReq);
		}
		
		private function onUrlLoaderComplete(event : Event) : void 
		{
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			var XMLdata : XML = new XML(event.target.data);
			
			// Create VerifyError: Error #1025: An invalid register 2 was accessed.
			default xml namespace = XMLdata.namespace();	// fix xmlns problem	
			var xmlList : XMLList= XMLdata.body.div.p;
			
			var body : XML = XMLdata.elements('*')[1];
			var bodyNS : Namespace = body.namespace(); 
			body.removeNamespace(bodyNS);
			var firstDiv : XML = body.elements('*')[0];
			for each ( var element:XML in firstDiv .elements( ) ) 
			{
				var paraObj : ParagraphObj = new ParagraphObj();
				paraObj.text = element.normalize();
				paraObj.begin = element.@begin;
				paraObj.dur = element.@dur;
				
				paragraphCollection.push(paraObj);
				
//				trace('-------------');
//				trace( element.normalize());
//				trace('element.name(): ' + (element.name()));
//				trace('element.children(): ' + (element.children()));
//				trace('element.childIndex(): ' + (element.childIndex()));
//				trace('element.namespace(): ' + (element.namespace()));
//				trace('element.namespaceDeclarations(): ' + (element.namespaceDeclarations()));
//				element.removeNamespace(element.namespace());
//				trace('element.namespace(): ' + (element.namespace()));
			}
			
			// Old way to ignore whitespace.
//			var xmlDoc :XMLDocument = new XMLDocument();
//			xmlDoc.ignoreWhite = true;
//			xmlDoc.parseXML(event.target.data);
//			
//			var firstChild : XMLNode = xmlDoc.firstChild;
//			var childNodes : Array = firstChild.childNodes; 
//			
//			for each(var item : XMLNode in childNodes){
//				var dataObj : DataObj = new DataObj();
//				dataObj.h2 = item.;
//			}
			
//			for each(var item : XML in xmlList) 
//			{
//				var dataObj : DataObj = new DataObj();
//				dataObj.h2 = item.h2;
//				dataObj.imgSrc = item.img.@src;
// 				dataObj.copy = item.div;
//				
//				dataObjs.push(dataObj);
//			}
			_hasCC = true;
			
			// rollback to avoid error: Error #1025: An invalid register 2 was accessed.
			default xml namespace = new Namespace("");
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getParaObj() : ParagraphObj{
			return paragraphCollection[0];
		}
		
		public function get hasCC() : Boolean{
			return _hasCC;
		}
		
//		private function onSubtitlesXmlLoadComplete(e:Event):void 
//		{
//			_subtitlesXml = new XML(e.target.data);
//			trace("ORIGINAL TIMEDTEXT XML:\n" + _subtitlesXml.toString());
//			var myXmlStr:String = _subtitlesXml.toString();
//			var xmlnsPattern:RegExp = new RegExp("xmlns[^\"]*\"[^\"]*\"", "gi");
//			myXmlStr = myXmlStr.replace(xmlnsPattern, "");
//			myXmlStr = myXmlStr.replace("aaa:lang=\"en\"", "");
//			_subtitlesXml = new XML(myXmlStr);
//			trace("MODIFIED TIMEDTEXT XML:\n" + _subtitlesXml.toString());
//
//			var numCaptions:int = _subtitlesXml.body.div.p.length();
//			trace("numCaptions: " + numCaptions);
//		}
	}
}

