package com.away3d.gloop.screens
{
	import flash.display.Sprite;
	
	public class ScreenBase extends Sprite
	{
		private var _initialized : Boolean;
		
		public function ScreenBase()
		{
			super();
		}
		
		
		public function init() : void
		{
			if (!_initialized) {
				initScreen();
			}
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