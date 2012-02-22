package com.away3d.gloop.level
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LevelDatabase extends EventDispatcher
	{
		private var _levels : Vector.<LevelProxy>;
		private var _selected : LevelProxy;
		
		
		public function LevelDatabase()
		{
			_levels = new Vector.<LevelProxy>();
		}
		
		
		public function get levels() : Vector.<LevelProxy>
		{
			return _levels;
		}
		
		
		public function get selectedProxy() : LevelProxy
		{
			return _selected;
		}
		
		
		public function select(proxy : LevelProxy) : void
		{
			_selected = proxy;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		
		public function getStateXml() : XML
		{
			var i : uint;
			var xml : XML;
			
			xml = new XML('<state/>');
			
			for (i=0; i<_levels.length; i++) {
				if (_levels[i].completed) {
					xml.appendChild(_levels[i].getStateXml());
				}
			}
			
			return xml;
		}
		
		
		public function loadXml(url : String) : void
		{
			var xml_loader : URLLoader;
			
			xml_loader = new URLLoader();
			xml_loader.addEventListener(Event.COMPLETE, onXmlLoaderComplete);
			xml_loader.load(new URLRequest(url));
		}
		
		
		private function onXmlLoaderComplete(ev : Event) : void
		{
			var xml : XML;
			var level_xml : XML;
			var xml_loader : URLLoader;
			
			xml_loader = URLLoader(ev.currentTarget);
			xml_loader.removeEventListener(Event.COMPLETE, onXmlLoaderComplete);
			xml = new XML(xml_loader.data);
			
			for each (level_xml in xml.level) {
				var level : LevelProxy;
				
				level = new LevelProxy();
				level.parseXml(level_xml);
				
				_levels.push(level);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}