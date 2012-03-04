package com.away3d.gloop.screens.levelselect
{
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.lib.StarTotalUI;
	
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	public class StarTotal extends Sprite
	{
		private var _db : LevelDatabase;
		
		private var _ui : StarTotalUI;
		
		public function StarTotal(db : LevelDatabase)
		{
			super();
			
			_db = db;
			
			init();
		}
		
		
		private function init() : void
		{
			_ui = new StarTotalUI();
			_ui.labelTextfield.autoSize = TextFieldAutoSize.LEFT;
			_ui.labelTextfield.text = '';
			addChild(_ui);
		}
		
		
		public function redraw() : void
		{
			if (_db.selectedChapter) {
				var stars : uint;
				
				stars = _db.selectedChapter.calcTotalStarsCollected();
				_ui.labelTextfield.text = stars.toString();
			}
		}
	}
}