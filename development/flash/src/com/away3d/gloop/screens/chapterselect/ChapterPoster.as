package com.away3d.gloop.screens.chapterselect
{
	import com.away3d.gloop.level.ChapterData;
	import com.away3d.gloop.lib.ChapterPosterUI;
	
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	public class ChapterPoster extends Sprite
	{
		private var _ui : ChapterPosterUI;
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
			
			_ui = new ChapterPosterUI();
			_ui.titleTextfield.autoSize = TextFieldAutoSize.LEFT;
			_ui.titleTextfield.text = _data.title;
			_ui.x = -(_ui.width/2);
			_ui.y = _bmp.getBounds(this).bottom;
			addChild(_ui);
		}
		
		
		public function get chapterData() : ChapterData
		{
			return _data;
		}
	}
}