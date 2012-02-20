package com.away3d.gloop.gameobjects.hoops
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	import wck.BodyShape;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends DefaultGameObject
	{
		
		public function Hoop(worldX : Number = 0, worldY : Number = 0, rotation : Number = 0)
		{
			_physics = new HoopPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;
			
			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			_physics.linearDamping = 100;
			
			_physics.reportBeginContact = true;
			
			_physics.allowDragging = true;
			
			
			_physics.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
		}
		
		private function handleBeginContact(e : ContactEvent) : void
		{			
			var otherPhysics:PhysicsComponent = e.other.m_userData as PhysicsComponent;
			if (!otherPhysics) return;
			var gloop:Gloop = otherPhysics.gameObject as Gloop;
			if (!gloop) return;
			onCollidingWithGloopStart(gloop);
		}
		
		protected function onCollidingWithGloopStart(gloop:Gloop):void {
			
		}

	}

}

import Box2DAS.Dynamics.b2Filter;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;

class HoopPhysicsComponent extends PhysicsComponent
{
	
	private static const RADIUS : Number = 60;
	
	public function HoopPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(0x947D3A);
		graphics.drawCircle(0, 0, RADIUS);
		graphics.beginFill(0xCEBC84);
		graphics.drawRect(-RADIUS / 2, -RADIUS / 2, RADIUS, RADIUS);
	
	}
	
	public override function shapes() : void
	{
		// used for gloop collision
		circle(RADIUS / 2);
		
		// used for collision with the world
		circle(RADIUS);
	}
	
	override public function create():void {
		super.create();
		b2fixtures[0].SetSensor(true);
		setCollisionGroup(HOOP_SENSOR, b2fixtures[0]);
		setCollisionGroup(HOOP, b2fixtures[1]);
	}
}