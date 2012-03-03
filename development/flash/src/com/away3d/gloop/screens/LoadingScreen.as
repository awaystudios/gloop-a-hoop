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
			
			_musicTheme = null;
		}
		
		
		protected override function initScreen() : void
		{
			_bmp = new Bitmap(new LoadingBitmap());
			_bmp.x = -_bmp.width/2;
			_bmp.y = -_bmp.height/2;
			_ctr.addChild(_bmp);
		}
	}
}