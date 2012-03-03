package com.away3d.gloop.screens.levelselect
{
	import com.away3d.gloop.level.LevelProxy;
	import com.away3d.gloop.lib.LevelThumbUI;
	
	import flash.display.Sprite;
	
	public class LevelThumb extends Sprite
	{
		private var _ui : LevelThumbUI;
		private var _proxy : LevelProxy;
		
		public function LevelThumb(proxy : LevelProxy)
		{
			super();
			
			_proxy = proxy;
			
			init();
		}
		
		
		private function init() : void
		{
			_ui = new LevelThumbUI();
			_ui.indexTextfield.text = (_proxy.indexInChapter+1).toString();
			_ui.blob0.visible = (_proxy.bestStarsCollected > 0);
			_ui.blob1.visible = (_proxy.bestStarsCollected > 1);
			_ui.blob2.visible = (_proxy.bestStarsCollected > 2);
			addChild(_ui);
		}
		
		
		public function get levelProxy() : LevelProxy
		{
			return _proxy;
		}
	}
}