package com.away3d.gloop.screens.win
{
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.LevelProxy;
	import com.away3d.gloop.lib.WinScreenUI;
	import com.away3d.gloop.screens.ScreenBase;
	import com.away3d.gloop.screens.ScreenStack;
	import com.away3d.gloop.screens.Screens;
	import com.away3d.gloop.sound.SoundManager;
	import com.away3d.gloop.sound.Sounds;
	
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class WinScreen extends ScreenBase
	{
		private var _ui : WinScreenUI;
		
		private var _db : LevelDatabase;
		private var _stack : ScreenStack;
		
		private var _dimCtf : ColorTransform;
		private var _normalCtf : ColorTransform;
		
		public function WinScreen(db : LevelDatabase, stack : ScreenStack)
		{
			super();
			
			_db = db;
			_stack = stack;
		}
		
		
		protected override function initScreen():void
		{
			_ui = new WinScreenUI();
			_ui.x = _w/2;
			_ui.y = _h/2.5;
			addChild(_ui);
			
			_ui.replayButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			_ui.menuButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			_ui.nextButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			_dimCtf = new ColorTransform(0, 0, 0, 1, 0x48, 0x1e, 0x3c);
			_normalCtf = new ColorTransform;
		}
		
		
		public override function activate() : void
		{
			var proxy : LevelProxy;
			
			proxy = _db.selectedLevelProxy;
			
			_ui.scoreTextfield.text = proxy.calcRoundScore().toString();
			_ui.blob0.transform.colorTransform = (proxy.starsCollected > 0) ? _normalCtf : _dimCtf;
			_ui.blob1.transform.colorTransform = (proxy.starsCollected > 1) ? _normalCtf : _dimCtf;
			_ui.blob2.transform.colorTransform = (_db.selectedLevelProxy.starsCollected > 2) ? _normalCtf : _dimCtf;
		}
		
		
		private function onButtonClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			
			switch (ev.currentTarget) {
				case _ui.replayButton:
					_stack.gotoScreen(Screens.GAME);
					break;
				case _ui.menuButton:
					_stack.gotoScreen(Screens.START);
					break;
				case _ui.nextButton:
					// TODO: Implement this
					break;
			}
		}
	}
}