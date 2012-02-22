package com.away3d.gloop.level
{
	import com.away3d.gloop.events.GameEvent;
	
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
			_selected.addEventListener(GameEvent.LEVEL_LOSE, onSelectedGameEvent);
			_selected.addEventListener(GameEvent.LEVEL_WIN, onSelectedGameEvent);
			
			dispatchEvent(new GameEvent(GameEvent.LEVEL_SELECT));
		}
		
		
		public function getStateXml() : XML
		{
			var i : uint;
			var xml : XML;
			
			xml = new XML('<state><levels/></state>');
			
			for (i=0; i<_levels.length; i++) {
				if (_levels[i].completed) {
					xml.levels.appendChild(_levels[i].getStateXml());
				}
			}
			
			return xml;
		}
		
		
		public function setStateFromXml(xml : XML) : void
		{
			var level_xml : XML;
			
			for each (level_xml in xml.levels.level) {
				var id : int;
				var level : LevelProxy;
				
				id = parseInt(level_xml.@id.toString());
				level = getLevelById(id);
				if (level)
					level.setStateFromXml(level_xml);
			}
		}
		
		
		public function loadXml(url : String) : void
		{
			var xml_loader : URLLoader;
			
			xml_loader = new URLLoader();
			xml_loader.addEventListener(Event.COMPLETE, onXmlLoaderComplete);
			xml_loader.load(new URLRequest(url));
		}
		
		
		private function deselectCurrent() : void
		{
			if (_selected) {
				_selected.removeEventListener(GameEvent.LEVEL_LOSE, onSelectedGameEvent);
				_selected.removeEventListener(GameEvent.LEVEL_WIN, onSelectedGameEvent);
			}
		}
		
		
		private function getLevelById(id : int) : LevelProxy
		{
			var i : uint;
			
			for (i=0; i<_levels.length; i++) {
				if (_levels[i].id == id)
					return _levels[i];
			}
			
			return null;
		}
		
		
		private function onSelectedGameEvent(ev : GameEvent) : void
		{
			dispatchEvent(ev.clone());
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