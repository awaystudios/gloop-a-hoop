package com.away3d.gloop.screens.game
{
	import com.away3d.gloop.lib.buttons.LevelSelectButton;
	import com.away3d.gloop.lib.buttons.MainMenuButton;
	import com.away3d.gloop.lib.buttons.ResumeButton;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	
	public class PauseOverlay extends Sprite
	{
		private var _w : Number;
		private var _h : Number;
		
		private var _resumeBtn : ResumeButton;
		private var _mainMenuBtn : MainMenuButton;
		private var _levelSelectBtn : LevelSelectButton;
		
		public function PauseOverlay(w : Number, h : Number)
		{
			super();
			
			_w = w;
			_h = h;
			
			init();
		}
		
		
		private function init() : void
		{
			graphics.beginFill(0, 0.5);
			graphics.drawRect(0, 0, _w, _h);
			
			_resumeBtn = new ResumeButton();
			_resumeBtn.x = _w/2 - _resumeBtn.width/2;
			_resumeBtn.y = 0.3 * _h;
			addChild(_resumeBtn);
			
			_mainMenuBtn = new MainMenuButton();
			_mainMenuBtn.x = _w/2 - _mainMenuBtn.width/2;
			_mainMenuBtn.y = _resumeBtn.y + 140;
			addChild(_mainMenuBtn);
			
			_levelSelectBtn = new LevelSelectButton();
			_levelSelectBtn.x = _w/2 - _levelSelectBtn.width/2;
			_levelSelectBtn.y = _resumeBtn.y + 280;
			addChild(_levelSelectBtn);
		}
		
		
		public function get resumeButton() : InteractiveObject
		{
			return _resumeBtn;
		}
		
		
		public function get mainMenuButton() : InteractiveObject
		{
			return _mainMenuBtn;
		}
		
		
		public function get levelSelectButton() : InteractiveObject
		{
			return _levelSelectBtn;
		}
	}
}