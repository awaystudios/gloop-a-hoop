package com.away3d.gloop.gameobjects {
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Wall extends DefaultGameObject {
		
		public function Wall(x:Number, y:Number, w:Number, h:Number) {
			super();
			_physics = new WallPhysicsComponent(w, h);
			_physics.x = x;
			_physics.y = y;
			_physics.type = 'Static';
		}
		
	}

}


import com.away3d.gloop.gameobjects.components.PhysicsComponent;

class WallPhysicsComponent extends PhysicsComponent {
	
	private var _w:Number;
	private var _h:Number;
	
	public function WallPhysicsComponent(w:Number, h:Number) {
		_w = w;
		_h = h;
		graphics.beginFill(0x642BA4);
		graphics.drawRect(-_w/2, -_h/2, _w, _h);
	}
	
	public override function shapes():void {
		box(_w, _h);
	}
	
}