package com.away3d.gloop.gameobjects
{
	import flash.events.EventDispatcher;
	
	public class GameObject extends EventDispatcher
	{
		public function GameObject()
		{
		}
		
		public function update(dt : Number) : void
		{
		}
		
		public function dispose() : void
		{
			// To be overridden
		}
	}
}