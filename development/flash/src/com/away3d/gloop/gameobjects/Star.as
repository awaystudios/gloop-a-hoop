package com.away3d.gloop.gameobjects
{
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	
	public class Star extends DefaultGameObject
	{
		public function Star(worldX:Number = 0, worldY:Number = 0)
		{
			_physics = new StarPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.applyGravity = false;
			_physics.isSensor = true;
		}
		
		override public function onCollidingWithGloopStart(gloop:Gloop):void {
			super.onCollidingWithGloopStart(gloop);
			trace("star!");
		}
	}
}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;

class StarPhysicsComponent extends PhysicsComponent
{
	
	private static const RADIUS : Number = 30;
	
	public function StarPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawCircle(0, 0, RADIUS);
	}
	
	public override function shapes() : void
	{
		circle(RADIUS);
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(GLOOP_SENSOR);
	}
}