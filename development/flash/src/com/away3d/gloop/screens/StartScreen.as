package com.away3d.gloop.screens
{
	import com.away3d.gloop.lib.LogoBitmap;
	import com.away3d.gloop.lib.buttons.PlayButton;
	import com.away3d.gloop.lib.buttons.SettingsButton;
	
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class StartScreen extends ScreenBase
	{
		private var _stack : ScreenStack;
		
		private var _logo : Bitmap;
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
			
			_logo = new Bitmap(new LogoBitmap);
			_logo.x = _w/2 - _logo.width/2;
			_logo.y = 0.14 * _h;
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
		
		
		private function onSettingsBtnClick(ev : MouseEvent) : void
		{
		}
		
		
		private function onPlayBtnClick(ev : MouseEvent) : void
		{
			_stack.gotoScreen(Screens.CHAPTERS);
		}
	}
}