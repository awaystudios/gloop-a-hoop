package com.away3d.gloop.screens.win
{
	import com.away3d.gloop.screens.ScreenBase;
	import com.away3d.gloop.screens.ScreenStack;
	import com.away3d.gloop.screens.Screens;
	
	import flash.events.MouseEvent;
	
	public class WinScreen extends ScreenBase
	{
		private var _stack : ScreenStack;
		
		public function WinScreen(stack : ScreenStack)
		{
			super();
			
			_stack = stack;
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, 1200, 800);
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		
		private function onClick(ev : MouseEvent) : void
		{
			_stack.gotoScreen(Screens.LEVELS);
		}
	}
}