package com.away3d.gloop.screens.chapterselect
{
	import com.away3d.gloop.level.ChapterData;
	
	import flash.display.Sprite;
	
	public class ChapterPoster extends Sprite
	{
		private var _data : ChapterData;
		
		public function ChapterPoster(data : ChapterData)
		{
			super();
			
			_data = data;
			
			graphics.beginFill(0xffcc00);
			graphics.drawRect(-300, -200, 600, 400);
		}
		
		
		public function get chapterData() : ChapterData
		{
			return _data;
		}
	}
}