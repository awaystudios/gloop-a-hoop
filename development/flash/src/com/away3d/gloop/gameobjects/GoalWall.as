package com.away3d.gloop.gameobjects {
	import Box2DAS.Dynamics.ContactEvent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GoalWall extends Wall {
		
		public function GoalWall(offsetX:Number, offsetY:Number, width:Number, height:Number, worldX:Number = 0, worldY:Number = 0) {
			super(offsetX, offsetY, width, height, worldX, worldY);
			_physics.reportBeginContact = true;
			_physics.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
		}
		
		private function handleBeginContact(e:ContactEvent):void {
			var otherPhysics:PhysicsComponent = e.other.m_userData as PhysicsComponent;
			if (!otherPhysics) return;
			var gloop:Gloop = otherPhysics.gameObject as Gloop;
			if (!gloop) return;
			
			trace("Goal!");
		}
		
		override public function get debugColor1():uint {
			return 0x28a696;
		}
		
	}

}