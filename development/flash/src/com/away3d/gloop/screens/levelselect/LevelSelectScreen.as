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
		private var _masterScaleY : Number;
		private var _masterScaleX : Number;
		private var _masterScale : Number;
		
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
			// Based on 1024x768 which was the
			// template for the design
			_masterScaleX = _w/1024;
			_masterScaleY = _h/768;
			_masterScale = (_masterScaleX + _masterScaleY)/2
			
			_thumbs = new Vector.<LevelThumb>();
			
			_totalStars = new StarTotal(_db);
			_totalStars.x = _w - 140 * _masterScaleY;
			_totalStars.y = 24 * _masterScaleY;
			_totalStars.scaleX = _masterScaleY;
			_totalStars.scaleY = _masterScaleY;
			addChild(_totalStars);
			
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
		}
		
		
		public override function activate() : void
		{
			var i : uint;
			var len : uint;
			var cols : uint;
			var rows : uint;
			var tlx : Number;
			var tly : Number;
			
			super.activate();
				
			len = _thumbs.length;
			
			for (i=0; i<len; i++)
				if (_thumbs[i].parent == this)
					removeChild(_thumbs[i]);
			
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
			
			tlx = _w/2 - cols * 70 * _masterScale;
			tly = _h/2 - rows * 75 * _masterScale + 40 * _masterScaleY;
			
			
			for (i=0; i<len; i++) {
				var thumb : LevelThumb;
				var level : LevelProxy;
				var row : uint;
				var col : uint;
				
				row = Math.floor(i / cols);
				col = i % cols;
				
				level = _db.selectedChapter.levels[i];
				
				if (_thumbs.length == i) {
					_thumbs.push(thumb = new LevelThumb(level));
					thumb.addEventListener(MouseEvent.CLICK, onThumbClick);
				} else {
					thumb = _thumbs[i];
					thumb.levelProxy = level;
				}
				
				thumb.x = tlx + col * 140 * _masterScale;
				thumb.y = tly + row * 150 * _masterScale;
				thumb.scaleX = _masterScaleX;
				thumb.scaleY = _masterScaleX;
				
				addChild(thumb);
			}
			
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