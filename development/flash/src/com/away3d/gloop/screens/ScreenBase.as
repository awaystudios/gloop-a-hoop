package com.away3d.gloop.screens
{
	import com.away3d.gloop.lib.BackgroundBitmap;
	import com.away3d.gloop.lib.buttons.BackButton;
	import com.away3d.gloop.sound.MusicManager;
	import com.away3d.gloop.sound.Themes;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	
	public class ScreenBase extends Sprite
	{
		protected var _w : Number;
		protected var _h : Number;
		
		protected var _musicTheme : String;
		
		protected var _backBtn : BackButton;
		
		protected var _ctr : Sprite;
		
		private var _drawBg : Boolean;
		private var _useBackBtn : Boolean;
		private var _initialized : Boolean;
		
		private var _background : Shape;
		
		public function ScreenBase(drawBackground : Boolean = true, useBackButton : Boolean = false)
		{
			super();
			
			_musicTheme = Themes.MAIN_THEME;
			
			_drawBg = drawBackground;
			_useBackBtn = useBackButton;
		}
		
		
		public function init(w : Number, h : Number) : void
		{
			_w = w;
			_h = h;
			
			if (!_initialized) {
				var masterScale : Number;
				
				// Based on 1024x768 which was the
				// template for the design
				masterScale = _h/768;
				
				if (_drawBg) {
					var bmp : BitmapData;
					var scale : Number;
					var mtx : Matrix;
					
					var bgWidth:Number = _w * 1.2;
					var bgHeight:Number = _h * 1.2;
					
					bmp = new BackgroundBitmap();
					scale = Math.max(bgWidth / bmp.width, bgHeight / bmp.height);
					
					mtx = new Matrix(scale, 0, 0, scale);
					mtx.translate( -bgWidth / 2, -bgHeight / 2);
					
					_background = new Shape;
					_background.graphics.beginBitmapFill(bmp, mtx, false, true);
					_background.graphics.drawRect( -bgWidth / 2, -bgHeight / 2, bgWidth, bgHeight);
					_background.x = _w / 2;
					_background.y = _h / 2;
					
					addChild(_background);
				}
				
				if (_useBackBtn) {
					_backBtn = new BackButton();
					_backBtn.x = masterScale * 20;
					_backBtn.y = masterScale * 20;
					_backBtn.scaleX = masterScale;
					_backBtn.scaleY = masterScale;
					addChild(_backBtn);
				}
				
				_ctr = new Sprite();
				_ctr.x = _w/2;
				_ctr.y = _h/2;
				_ctr.scaleX = _ctr.scaleY = masterScale;
				addChild(_ctr);
				
				initScreen();
				_initialized = true;
			}
		}
		
		private function onEnterFrame(e:Event):void {
			update();
			if (_drawBg) {
				/*
				var t:Number = getTimer();
				_background.rotation = Math.sin(t / 600) * 3;
				*/
			}
		}
		
		
		public function get musicTheme() : String
		{
			return _musicTheme;
		}
		
		public function get screenWidth() : Number
		{
			return _w;
		}
		
		
		public function get screenHeight() : Number
		{
			return _h;
		}
		
		
		public function activate() : void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			// To be overridden
		}
		
		
		public function deactivate() : void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			// To be overridden
		}
		
		
		protected function initScreen() : void
		{
			// To be overridden
		}
		
		protected function update():void {
			// To be overridden
		}
	}
}