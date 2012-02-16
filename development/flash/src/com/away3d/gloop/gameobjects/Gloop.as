package com.away3d.gloop.gameobjects
{
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	public class Gloop extends DefaultGameObject
	{
		public function Gloop()
		{
			super();
			_physics = new GloopPhysicsComponent();
			_physics.angularDamping = 1;
			_physics.friction = 1;
			_physics.restitution = .75;
		}
	}
}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;

class GloopPhysicsComponent extends PhysicsComponent {
	
	private static const RADIUS:Number = 30;
	
	public function GloopPhysicsComponent() {
		graphics.beginFill(0x84C806);
		graphics.drawCircle(0, 0, RADIUS);
		graphics.beginFill(0x7DA628);
		graphics.drawRect(-RADIUS / 2, -RADIUS / 2, RADIUS, RADIUS);
		
	}
	
	public override function shapes():void {
		circle(RADIUS);
	}
}