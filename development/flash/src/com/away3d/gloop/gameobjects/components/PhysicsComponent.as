package com.away3d.gloop.gameobjects.components
{
	
	import Box2DAS.Dynamics.b2Fixture;
	import wck.BodyShape;

	public class PhysicsComponent extends BodyShape
	{
		
		public static const HOOP	:int = 1;
		public static const GLOOP	:int = 2;
		public static const LEVEL	:int = 4;
		
		public function PhysicsComponent()
		{
			
		}
		
		public function setAsStatic():void {
			type = 'Static';
		}
		
		protected function setCollisionGroup(group:int, fixture:b2Fixture = null):void {
			fixture ||= b2fixtures[0];
			
			switch(group) {
				case HOOP : 
					fixture.SetFilterData( { categoryBits: HOOP, maskBits: LEVEL, groupIndex: 0 } );
					break;
				case GLOOP : 
					fixture.SetFilterData( { categoryBits: GLOOP, maskBits: LEVEL | GLOOP, groupIndex: 0 } );
					break;
				case LEVEL : 
					fixture.SetFilterData( { categoryBits: LEVEL, maskBits: GLOOP | HOOP, groupIndex: 0 } );
					break;
			}
			
		}
		
	}
}