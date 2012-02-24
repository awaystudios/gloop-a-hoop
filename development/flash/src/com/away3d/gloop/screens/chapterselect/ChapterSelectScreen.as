package com.away3d.gloop.screens.chapterselect
{
	import com.away3d.gloop.level.ChapterData;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.screens.ScreenBase;
	
	import flash.events.MouseEvent;
	
	public class ChapterSelectScreen extends ScreenBase
	{
		private var _db : LevelDatabase;
		private var _posters : Vector.<ChapterPoster>;
		
		public function ChapterSelectScreen(db : LevelDatabase)
		{
			super();
			
			_db = db;
		}
		
		
		protected override function initScreen():void
		{
			var i : uint;
			var len : uint;
			
			len = _db.chapters.length;
			for (i=0; i<len; i++) {
				var chapter : ChapterData;
				var poster : ChapterPoster;
				
				chapter = _db.chapters[i];
				poster = new ChapterPoster(chapter);
				poster.x = i*120;
				poster.addEventListener(MouseEvent.CLICK, onPosterClick);
				addChild(poster);
			}
		}
		
		
		private function onPosterClick(ev : MouseEvent) : void
		{
			var poster : ChapterPoster;
			
			poster = ChapterPoster(ev.currentTarget);
			_db.selectChapter(poster.chapterData);
		}
	}
}