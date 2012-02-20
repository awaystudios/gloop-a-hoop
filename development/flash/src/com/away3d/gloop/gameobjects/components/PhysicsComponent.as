package com.away3d.gloop.gameobjects.components
{
	
	import Box2DAS.Common.M22;
	import Box2DAS.Common.V2;
	import Box2DAS.Common.XF;
	import Box2DAS.Dynamics.b2Fixture;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import wck.BodyShape;

	public class PhysicsComponent extends BodyShape
	{
		private var _gameObject:DefaultGameObject;
		
		public static const HOOP		:int = 1;
		public static const HOOP_SENSOR	:int = 2;
		public static const GLOOP		:int = 4;
		public static const LEVEL		:int = 8;
		
		public function PhysicsComponent(gameObject:DefaultGameObject)
		{
			_gameObject = gameObject;
		}
		
		public function setStatic(static:Boolean = true):void {
			if ( static ) {
				type = 'Static';
			} else {
				type = 'Dynamic';
			}
		}
		
		/**
		 * Draws the object as seen by Box2D, useful for debugging, might be inaccurate if used after initialization phase
		 */
		public function drawBox2D():void {
			graphics.clear();
			graphics.beginFill(_gameObject.debugColor1, .1);
			graphics.lineStyle(2, _gameObject.debugColor2, 1);
			var xf:XF = new XF;
			for each(var fixture:b2Fixture in b2fixtures) {
				fixture.Draw(graphics, this.b2body.GetTransform(), 60);
			}
		}
		
		/**
		 * Defines which other types of objects this fixture will collide with
		 * @param	group	The group this fixture belongs to. (Note that this is not the group to collide with, that is dealt with internally)
		 * @param	fixture	The fixture to apply the grouping to. 
		 */
		protected function setCollisionGroup(group:int, fixture:b2Fixture = null):void {
			fixture ||= b2fixtures[0];
			
			switch(group) {
				case HOOP : 
					fixture.SetFilterData( { categoryBits: HOOP, maskBits: LEVEL, groupIndex: 0 } );
					break;
				case HOOP_SENSOR : 
					fixture.SetFilterData( { categoryBits: HOOP_SENSOR, maskBits: GLOOP, groupIndex: 0 } );
					break;
				case GLOOP : 
					fixture.SetFilterData( { categoryBits: GLOOP, maskBits: LEVEL | GLOOP | HOOP_SENSOR, groupIndex: 0 } );
					break;
				case LEVEL : 
					fixture.SetFilterData( { categoryBits: LEVEL, maskBits: GLOOP | HOOP, groupIndex: 0 } );
					break;
			}
			
		}
		
		public function get gameObject():DefaultGameObject {
			return _gameObject;
		}
		
		public function get isStatic():Boolean {
			return type == 'Static';
		}
		
	}
}