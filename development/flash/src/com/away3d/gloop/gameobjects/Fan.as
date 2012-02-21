package com.away3d.gloop.gameobjects
{
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	
	public class Fan extends Hoop implements IButtonControllable
	{
		private var _btnGroup : uint;
		
		public function Fan(worldX:Number=0, worldY:Number=0, rotation:Number=0, btnGroup : uint = 0)
		{
			super(worldX, worldY, rotation);
			
			_btnGroup = btnGroup;
		}
		
		
		public function get buttonGroup() : uint
		{
			return _btnGroup;
		}
		
		
		public function toggleOn() : void
		{
			trace(this, 'toggle on!');
		}
		
		
		public function toggleOff() : void
		{
			trace(this, 'toggle off!');
		}
	}
}