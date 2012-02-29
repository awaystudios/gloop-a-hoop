package com.away3d.gloop.screens.chapterselect
{
	import com.away3d.gloop.level.ChapterData;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class ChapterPoster extends Sprite
	{
		private var _data : ChapterData;
		private var _bmp : Bitmap;
		
		public function ChapterPoster(data : ChapterData)
		{
			super();
			
			_data = data;
			
			init();
		}
		
		
		private function init() : void
		{
			_bmp = new Bitmap(_data.posterBitmap);
			_bmp.x = -(_bmp.width/2);
			_bmp.y = -(_bmp.height/2);
			addChild(_bmp);
		}
		
		
		public function get chapterData() : ChapterData
		{
			return _data;
		}
	}
}