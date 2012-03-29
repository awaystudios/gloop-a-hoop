package com.away3d.gloop.screens.levelselect
{

	import com.away3d.gloop.Settings;
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
		
		private var _totalStars : StarTotal;
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
			var masterScaleY : Number;
			var masterScaleX : Number;
			var masterScale : Number;
			
			// Based on 1024x768 which was the
			// template for the design
			masterScaleX = _w/1024;
			masterScaleY = _h/768;
			masterScale = (masterScaleX + masterScaleY)/2
			
			len = _db.selectedChapter.levels.length;

			if( len < 9 ) {
				cols = 4;
			}
			else if( len < 16 ) {
				cols = 5;
			}
			else if( len < 25 ) {
				cols = 6;
			}
			else {
				cols = 7;
			}

			rows = Math.ceil(len / cols);

			tlx = _w/2 - cols * 70 * masterScale;
			tly = _h/2 - rows * 75 * masterScale + 40 * masterScaleY;
			
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
				thumb.x = tlx + col * 140 * masterScale;
				thumb.y = tly + row * 150 * masterScale;
				thumb.scaleX = masterScaleX;
				thumb.scaleY = masterScaleX;
				thumb.addEventListener(MouseEvent.CLICK, onThumbClick);
				
				addChild(thumb);
				_thumbs.push(thumb);
			}
			
			_totalStars = new StarTotal(_db);
			_totalStars.x = _w - 140 * masterScaleY;
			_totalStars.y = 24 * masterScaleY;
			_totalStars.scaleX = masterScaleY;
			_totalStars.scaleY = masterScaleY;
			addChild(_totalStars);
			
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
			
			_totalStars.redraw();
		}
		
		
		private function onThumbClick(ev : MouseEvent) : void
		{
			var thumb : LevelThumb;
			
			thumb = LevelThumb(ev.currentTarget);
			
			// Don't allow selection of locked levels
			if( !Settings.DEV_MODE ) {
				if( thumb.levelProxy.locked )
					return;
			}
			
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