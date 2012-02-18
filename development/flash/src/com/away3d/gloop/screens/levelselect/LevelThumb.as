package com.away3d.gloop.screens.levelselect
{
	import com.away3d.gloop.level.LevelProxy;
	
	import flash.display.Sprite;
	
	public class LevelThumb extends Sprite
	{
		private var _proxy : LevelProxy;
		
		public function LevelThumb(proxy : LevelProxy)
		{
			super();
			
			_proxy = proxy;
			
			graphics.beginFill(0xff00ff);
			graphics.drawRect(0, 0, 100, 100);
		}
		
		
		public function get levelProxy() : LevelProxy
		{
			return _proxy;
		}
	}
}