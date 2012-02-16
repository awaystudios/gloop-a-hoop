package com.away3d.gloop.gameobjects.components
{
	
	import wck.BodyShape;

	public class PhysicsComponent extends BodyShape
	{
		public function PhysicsComponent()
		{
			
		}
		
		public function setAsStatic():void {
			type = 'Static';
		}
		
	}
}