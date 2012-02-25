package com.away3d.gloop.gameobjects {
	import Box2DAS.Dynamics.ContactEvent;
	import com.away3d.gloop.gameobjects.components.GoalWallPhysicsComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GoalWall extends Wall {
		
		public function GoalWall(offsetX:Number, offsetY:Number, width:Number, height:Number, worldX:Number = 0, worldY:Number = 0) {
			_physics = new GoalWallPhysicsComponent(this, offsetX, offsetY, width, height);
			super(offsetX, offsetY, width, height, worldX, worldY);
		}
		
		override public function onCollidingWithGloopStart(gloop:Gloop):void {
			super.onCollidingWithGloopStart(gloop);
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_HIT_GOAL_WALL, this));
			gloop.onHitGoalWall();
		}
		
		public function onGloopEnterSensor(gloop:Gloop):void {
			// gloop goes into sensor
		}
		
		public function ongGloopExitSensor(gloop:Gloop):void {
			// gloop leaves sensor
		}
		
		override public function get debugColor1():uint {
			return 0x28a696;
		}
		
	}

}