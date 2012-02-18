package com.away3d.gloop.screens.levelselect
{
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.LevelProxy;
	import com.away3d.gloop.screens.ScreenBase;
	
	import flash.events.MouseEvent;

	public class LevelSelectScreen extends ScreenBase
	{
		private var _db : LevelDatabase;
		
		private var _thumbs : Vector.<LevelThumb>;
		
		public function LevelSelectScreen(db : LevelDatabase)
		{
			super();
			
			_db = db;
		}
		
		
		protected override function initScreen() : void
		{
			var i : uint;
			
			for (i=0; i<_db.levels.length; i++) {
				var thumb : LevelThumb;
				var level : LevelProxy;
				
				level = _db.levels[i];
				thumb = new LevelThumb(level);
				thumb.x = i*120;
				thumb.addEventListener(MouseEvent.CLICK, onThumbClick);
				addChild(thumb);
			}
		}
		
		
		private function onThumbClick(ev : MouseEvent) : void
		{
			var thumb : LevelThumb;
			
			thumb = LevelThumb(ev.currentTarget);
			_db.select(thumb.levelProxy);
		}
	}
}