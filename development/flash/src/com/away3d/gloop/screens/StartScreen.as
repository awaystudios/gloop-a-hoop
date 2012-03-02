package com.away3d.gloop.screens
{
	import com.away3d.gloop.lib.LogoBitmap;
	import com.away3d.gloop.lib.buttons.PlayButton;
	import com.away3d.gloop.lib.buttons.SettingsButton;
	import com.away3d.gloop.sound.SoundManager;
	import com.away3d.gloop.sound.Sounds;
	
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class StartScreen extends ScreenBase
	{
		private var _stack : ScreenStack;
		
		private var _logo : Sprite;
		private var _playBtn : SimpleButton;
		private var _settingsBtn : SimpleButton;
		
		public function StartScreen(stack : ScreenStack)
		{
			super();
			_stack = stack;
		}
		
		
		protected override function initScreen():void
		{
			super.initScreen();
			
			var logoBmp:Bitmap = new Bitmap(new LogoBitmap);
			logoBmp.smoothing = true;
			logoBmp.x = -logoBmp.width / 2;
			logoBmp.y = -logoBmp.height / 2;
			
			_logo = new Sprite();
			_logo.x = _w / 2;
			
			_logo.addChild(logoBmp);
			addChild(_logo);
			
			_playBtn = new PlayButton();
			_playBtn.x = _w/2 - _playBtn.width/2;
			_playBtn.y = 0.4 * _h;
			_playBtn.addEventListener(MouseEvent.CLICK, onPlayBtnClick);
			addChild(_playBtn);
			
			_settingsBtn = new SettingsButton();
			_settingsBtn.x = _w/2 - _settingsBtn.width/2;
			_settingsBtn.y = _playBtn.y + 140;
			_settingsBtn.addEventListener(MouseEvent.CLICK, onSettingsBtnClick);
			addChild(_settingsBtn);
		}
		
		override protected function update():void {
			var t:Number = getTimer();
			_logo.rotation = Math.sin(t / 300) * 1.5;
			_logo.scaleX = 1.0 + Math.cos(t / 150) * .025;
			_logo.y = 0.23 * _h + Math.cos(t / 300) * 7;
		}
		
		private function onSettingsBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.SETTINGS);
		}
		
		
		private function onPlayBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.CHAPTERS);
		}
		
		
	}
}