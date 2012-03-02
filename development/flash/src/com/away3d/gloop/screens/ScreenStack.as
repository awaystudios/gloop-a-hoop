package com.away3d.gloop.screens
{
	import flash.display.Sprite;

	public class ScreenStack
	{
		private var _w : Number;
		private var _h : Number;
		private var _ctr : Sprite;
		
		private var _screens : Vector.<ScreenBase>;
		private var _screens_by_id : Object;
		private var _active_screen : ScreenBase;
		
		public function ScreenStack(w : Number, h : Number, ctr : Sprite)
		{
			_w = w;
			_h = h;
			_ctr = ctr;
			
			_screens = new Vector.<ScreenBase>();
			_screens_by_id = {};
		}
		
		
		public function addScreen(id : String, screen : ScreenBase) : void
		{
			_screens_by_id[id] = screen;
			_screens.push(screen);
		}
		
		
		public function gotoScreen(id : String) : void
		{
			trace(id);
			if (_active_screen) {
				_active_screen.deactivate();
				_ctr.removeChild(_active_screen);
				_active_screen = null;
			}
			
			_active_screen = _screens_by_id[id];
			_active_screen.init(_w, _h);
			
			_ctr.addChild(_active_screen);
			_active_screen.activate();
		}
	}
}