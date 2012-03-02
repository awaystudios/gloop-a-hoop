package com.away3d.gloop.screens
{
	import com.away3d.gloop.lib.LoadingBitmap;
	
	import flash.display.Bitmap;

	public class LoadingScreen extends ScreenBase
	{
		private var _bmp : Bitmap;
		
		public function LoadingScreen()
		{
			super();
		}
		
		
		protected override function initScreen() : void
		{
			_bmp = new Bitmap(new LoadingBitmap());
			_bmp.x = _w/2 - _bmp.width/2;
			_bmp.y = _h/2 - _bmp.height/2;
			addChild(_bmp);
		}
	}
}