package com.away3d.gloop.screens
{
	import flash.display.Sprite;
	
	public class ScreenBase extends Sprite
	{
		protected var _w : Number;
		protected var _h : Number;
		
		private var _drawBg : Boolean;
		private var _initialized : Boolean;
		
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
					graphics.beginFill(0x444444);
					graphics.drawRect(0, 0, _w, _h);
				}
				
				initScreen();
				_initialized = true;
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
			// To be overridden
		}
		
		
		public function deactivate() : void
		{
			// To be overridden
		}
		
		
		protected function initScreen() : void
		{
			// To be overridden
		}
	}
}