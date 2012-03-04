package com.away3d.gloop.screens.levelselect
{
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.LevelProxy;
	import com.away3d.gloop.lib.buttons.BackButton;
	import com.away3d.gloop.screens.ScreenBase;
	import com.away3d.gloop.screens.ScreenStack;
	import com.away3d.gloop.screens.Screens;
	import com.away3d.gloop.sound.SoundManager;
	import com.away3d.gloop.sound.Sounds;
	
	import flash.events.MouseEvent;

	public class LevelSelectScreen extends ScreenBase
	{
		private var _db : LevelDatabase;
		private var _stack : ScreenStack;
		
		private var _thumbs : Vector.<LevelThumb>;
		
		public function LevelSelectScreen(db : LevelDatabase, stack : ScreenStack)
		{
			super(true, true);
			
			_db = db;
			_stack = stack;
		}
		
		
		protected override function initScreen() : void
		{
			var i : uint;
			var len : uint;
			var rows : uint;
			var cols : uint;
			var tlx : Number;
			var tly : Number;
			
			len = _db.selectedChapter.levels.length;
			rows = Math.ceil(len / 4);
			cols = (len < 4)? len : 4;
			
			tlx = _w/2 - cols * 70;
			tly = _h/2 - rows * 75;
			
			_thumbs = new Vector.<LevelThumb>();
			
			for (i=0; i<len; i++) {
				var thumb : LevelThumb;
				var level : LevelProxy;
				var row : uint;
				var col : uint;
				
				row = Math.floor(i / cols);
				col = i % cols;
				
				level = _db.selectedChapter.levels[i];
				thumb = new LevelThumb(level);
				thumb.x = tlx + col * 140;
				thumb.y = tly + row * 150;
				thumb.addEventListener(MouseEvent.CLICK, onThumbClick);
				
				addChild(thumb);
				_thumbs.push(thumb);
			}
			
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
		}
		
		
		public override function activate() : void
		{
			var i : uint;
			var len : uint;
			
			super.activate();
			
			len = _thumbs.length;
			for (i=0; i<len; i++) {
				_thumbs[i].redraw();
			}
		}
		
		
		private function onThumbClick(ev : MouseEvent) : void
		{
			var thumb : LevelThumb;
			
			thumb = LevelThumb(ev.currentTarget);
			
			// Don't allow selection of locked levels
			if (thumb.levelProxy.locked)
				return;
			
			SoundManager.play(Sounds.MENU_BUTTON);
			_db.selectLevel(thumb.levelProxy);
		}
		
		
		private function onBackBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.CHAPTERS);
		}
	}
}