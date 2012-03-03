package com.away3d.gloop.level
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;

	public class ChapterData extends EventDispatcher
	{
		private var _title : String;
		private var _posterUrl : String;
		
		private var _poster : BitmapData;
		
		private var _levels : Vector.<LevelProxy>;
		
		public function ChapterData()
		{
			_levels = new Vector.<LevelProxy>();
		}
		
		
		public function get levels() : Vector.<LevelProxy>
		{
			return _levels;
		}
		
		
		public function get title() : String
		{
			return _title;
		}
		
		
		public function get posterBitmap() : BitmapData
		{
			return _poster;
		}
		
		
		public function loadPoster() : void
		{
			var loader : Loader;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.load(new URLRequest(_posterUrl));
		}
		
		
		public function getLevelById(id : int) : LevelProxy
		{
			var i : uint;
			
			for (i=0; i<_levels.length; i++) {
				if (_levels[i].id == id)
					return _levels[i];
			}
			
			return null;
		}
		
		
		public function parseXml(xml : XML) : void
		{
			var idx : uint;
			var level_xml : XML;
			
			_title = xml.title.toString();
			_posterUrl = xml.@poster.toString();
			
			idx = 0;
			
			for each (level_xml in xml.level) {
				var level : LevelProxy;
				
				level = new LevelProxy(idx++);
				level.parseXml(level_xml);
				
				_levels.push(level);
			}
		}
		
		
		private function onLoaderComplete(ev : Event) : void
		{
			var info : LoaderInfo;
			
			info = LoaderInfo(ev.currentTarget);
			info.removeEventListener(Event.COMPLETE, onLoaderComplete);
			
			_poster = Bitmap(info.content).bitmapData;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}