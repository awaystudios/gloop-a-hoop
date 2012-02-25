package com.away3d.gloop.gameobjects.components
{
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.ContactEvent;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.Settings;
	import wck.BodyShape;
	
	public class PhysicsComponent extends BodyShape
	{
		private var _gameObject : DefaultGameObject;
		
		public static const HOOP : int = 1;
		public static const GLOOP_SENSOR : int = 2;
		public static const GLOOP : int = 4;
		public static const LEVEL : int = 8;
		
		public function PhysicsComponent(gameObject : DefaultGameObject)
		{
			_gameObject = gameObject;
			reportBeginContact = true;
			reportEndContact = true;
			addEventListener(ContactEvent.BEGIN_CONTACT, onBeginContact);
			addEventListener(ContactEvent.END_CONTACT, onEndContact);
		}
		
		public function setStatic(static : Boolean = true) : void
		{
			if (static)
			{
				type = 'Static';
			}
			else
			{
				type = 'Dynamic';
			}
		}
		
		public function moveTo(worldX:Number, worldY:Number, snapToGrid:Boolean ):void {
			var pos:V2 = new V2(worldX, worldY);
			
			if (snapToGrid) {
				pos.x = Hoop.snapToHoopGrid(pos.x);
				pos.y = Hoop.snapToHoopGrid(pos.y);
			}
			
			// physics are not intialized, we can set them on the visual object and wck will read them from here
			if (!b2body) {
				x = pos.x;
				y = pos.y;
				return;
			}

			// transform point into physics coord space
			pos.x /= Settings.PHYSICS_SCALE;
			pos.y /= Settings.PHYSICS_SCALE;
			
			var angle:Number = b2body.GetAngle();
			
			b2body.SetTransform(pos, angle);
			updateBodyMatrix(null); // updates the 2d view, the 3d will update the next frame
		}
		
		/**
		 * Draws the object as seen by Box2D, useful for debugging, might be inaccurate if used after initialization phase
		 */
		public function drawBox2D() : void
		{
			graphics.clear();
			graphics.beginFill(_gameObject.debugColor1, .1);
			graphics.lineStyle(2, _gameObject.debugColor2, 1);
			for each (var fixture : b2Fixture in b2fixtures)
			{
				fixture.Draw(graphics, this.b2body.GetTransform(), 60);
			}
		}
		
		/**
		 * Defines which other types of objects this fixture will collide with
		 * @param	group	The group this fixture belongs to. (Note that this is not the group to collide with, that is dealt with internally)
		 * @param	fixture	The fixture to apply the grouping to.
		 */
		protected function setCollisionGroup(group : int, fixture : b2Fixture = null) : void
		{
			fixture ||= b2fixtures[0];
			
			switch (group)
			{
				case HOOP: 
					fixture.SetFilterData({categoryBits: HOOP, maskBits: LEVEL | HOOP, groupIndex: 0});
					break;
				case GLOOP_SENSOR: 
					fixture.SetFilterData({categoryBits: GLOOP_SENSOR, maskBits: GLOOP, groupIndex: 0});
					break;
				case GLOOP: 
					fixture.SetFilterData({categoryBits: GLOOP, maskBits: LEVEL | GLOOP | GLOOP_SENSOR, groupIndex: 0});
					break;
				case LEVEL: 
					fixture.SetFilterData({categoryBits: LEVEL, maskBits: GLOOP | HOOP | LEVEL, groupIndex: 0});
					break;
			}
		
		}
		
		protected function onBeginContact(e : ContactEvent) : void
		{
			var gloop:Gloop = getGloop(e.other);
			if (!gloop) return;
			_gameObject.onCollidingWithGloopStart(gloop);
		}
		
		protected function onEndContact(e : ContactEvent ) : void
		{
			var gloop:Gloop = getGloop(e.other);
			if (!gloop) return;
			_gameObject.onCollidingWithGloopEnd(gloop);
		}
		
		private function getGloop(fixture:b2Fixture):Gloop {
			var otherPhysics : PhysicsComponent = fixture.m_userData as PhysicsComponent;
			if (!otherPhysics) return null;
			var gloop : Gloop = otherPhysics.gameObject as Gloop;
			return gloop;
		}
		
		public function get gameObject() : DefaultGameObject
		{
			return _gameObject;
		}
		
		public function get isStatic() : Boolean
		{
			return type == 'Static';
		}
	
	}
}