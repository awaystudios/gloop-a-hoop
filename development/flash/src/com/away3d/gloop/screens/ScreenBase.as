package com.away3d.gloop.screens
{
	import com.away3d.gloop.lib.BackgroundBitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class ScreenBase extends Sprite
	{
		protected var _w : Number;
		protected var _h : Number;
		
		private var _drawBg : Boolean;
		private var _initialized : Boolean;
		
		private var _background : Shape;
		
		public function ScreenBase(drawBackground : Boolean = true)
		{
			super();
			
			_drawBg = drawBackground;
		}
		
		
		public function init(w : Number, h : Number) : void
		{
			_w = w;
			_h = h;
			
			if (!_initialized) {
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
				
				initScreen();
				_initialized = true;
			}
		}
		
		private function onEnterFrame(e:Event):void {
			update();
			if (_drawBg) {
				var t:Number = getTimer();
				_background.rotation = Math.sin(t / 600) * 3;
			}
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