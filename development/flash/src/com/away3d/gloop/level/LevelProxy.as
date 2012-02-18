package com.away3d.gloop.level
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;

	public class LevelProxy extends EventDispatcher
	{
		private var _awd_url : String;
		private var _level : Level;
		
		public function LevelProxy()
		{
		}
		
		
		public function get level() : Level
		{
			return _level;
		}
		
		
		public function parseXml(xml : XML) : void
		{
			_awd_url = xml.@awd.toString();
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