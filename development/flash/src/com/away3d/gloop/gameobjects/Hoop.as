package com.away3d.gloop.gameobjects
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends DefaultGameObject
	{
		
		public function Hoop(worldX : Number = 0, worldY : Number = 0, rotation : Number = 0)
		{
			_physics = new HoopPhysicsComponent();
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;
			_physics.setAsStatic();
			_physics.isSensor = true;
			_physics.reportBeginContact = true;
			_physics.reportEndContact = true;
			
			_physics.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			_physics.addEventListener(ContactEvent.END_CONTACT, handleEndContact);
		}
		
		private function handleBeginContact(e : ContactEvent) : void
		{
			var pc:PhysicsComponent = e.relatedObject as PhysicsComponent;
			pc.linearVelocityY = -3;
		}
		
		private function handleEndContact(e : ContactEvent) : void
		{
			trace(e);
		}
	
	}

}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;

class HoopPhysicsComponent extends PhysicsComponent
{
	
	private static const RADIUS : Number = 60;
	
	public function HoopPhysicsComponent()
	{
		graphics.beginFill(0x947D3A);
		graphics.drawCircle(0, 0, RADIUS);
		graphics.beginFill(0xCEBC84);
		graphics.drawRect(-RADIUS / 2, -RADIUS / 2, RADIUS, RADIUS);
	
	}
	
	public override function shapes() : void
	{
		circle(RADIUS);
	}
}