package com.away3d.gloop.gameobjects
{
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	
	public class Button extends Hoop
	{
		private var _pressed : Boolean;
		private var _btnGroup : uint;
		
		private var _controllables : Vector.<IButtonControllable>;
		
		
		public function Button(worldX:Number=0, worldY:Number=0, rotation:Number=0, btnGroup : uint = 0)
		{
			super(worldX, worldY, rotation);
			
			_btnGroup = btnGroup;
			
			_controllables = new Vector.<IButtonControllable>();
		}
		
		
		public function get buttonGroup() : uint
		{
			return _btnGroup;
		}
		
		
		public function addControllable(controllable : IButtonControllable) : void
		{
			_controllables.push(controllable);
		}
		
		
		public override function onCollidingWithGloopStart(gloop : Gloop) : void
		{
			_pressed = !_pressed;
			
			if (_pressed) toggleOn();
			else toggleOff();
		}
		
		
		private function toggleOn() : void
		{
			var i : uint;
			
			_pressed = true;
			
			for (i=0; i<_controllables.length; i++) {
				_controllables[i].toggleOn();
			}
		}
		
		
		private function toggleOff() : void
		{
			var i : uint;
			
			_pressed = false;
			
			for (i=0; i<_controllables.length; i++) {
				_controllables[i].toggleOff();
			}
		}
	}
}