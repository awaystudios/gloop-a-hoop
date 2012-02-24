package com.away3d.gloop.level
{
	public class ChapterData
	{
		private var _title : String;
		private var _posterUrl : String;
		
		private var _levels : Vector.<LevelProxy>;
		
		public function ChapterData()
		{
			_levels = new Vector.<LevelProxy>();
		}
		
		
		public function get levels() : Vector.<LevelProxy>
		{
			return _levels;
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
			var level_xml : XML;
			
			_title = xml.title.toString();
			_posterUrl = xml.@poster.toString();
			
			for each (level_xml in xml.level) {
				var level : LevelProxy;
				
				level = new LevelProxy();
				level.parseXml(level_xml);
				
				_levels.push(level);
			}
		}
	}
}