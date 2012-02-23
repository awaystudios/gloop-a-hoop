package com.away3d.gloop.screens.win
{
	import com.away3d.gloop.screens.ScreenBase;
	
	public class WinScreen extends ScreenBase
	{
		public function WinScreen()
		{
			super();
			
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, 1200, 800);
		}
	}
}