package com.away3d.gloop.level
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;

	public class LevelProxy extends EventDispatcher
	{
		private var _id : int;
		private var _awd_url : String;
		private var _level : Level;
		
		private var _completed : Boolean;
		
		private var _inventory : Vector.<LevelInventoryItem>;
		
		
		public function LevelProxy()
		{
			_inventory = new Vector.<LevelInventoryItem>();
		}
		
		
		public function get level() : Level
		{
			return _level;
		}
		
		
		public function get id() : int
		{
			return _id;
		}
		
		
		public function get completed() : Boolean
		{
			return _completed;
		}
		
		
		public function parseXml(xml : XML) : void
		{
			var item_xml : XML;
			
			_id = parseInt(xml.@id.toString());
			_awd_url = xml.@awd.toString();
			
			for each (item_xml in xml.inventory.children()) {
				var item : LevelInventoryItem;
				
				item = new LevelInventoryItem(item_xml.name(), item_xml.@variant.toString());
				_inventory.push(item);
			}
		}
		
		
		public function getStateXml() : XML
		{
			var xml : XML;
			
			xml = new XML('<level/>');
			xml.@id = _id.toString();
			xml.@completed = _completed.toString();
			
			return xml;
		}
		
		
		public function setStateFromXml(xml : XML) : void
		{
			_completed = (xml.@completed.toString() == 'true');
		}
		
		
		public function load(forceReload : Boolean = false) : void
		{
			if (!_level || forceReload) {
				var loader : LevelLoader;
				
				loader = new LevelLoader(50);
				loader.addEventListener(Event.COMPLETE, onLevelComplete);
				loader.load(new URLRequest(_awd_url));
			}
			else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onLevelComplete(ev : Event) : void
		{
			var loader : LevelLoader;
			
			loader = LevelLoader(ev.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onLevelComplete);
			_level = loader.loadedLevel;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}