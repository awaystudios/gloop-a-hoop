package com.away3d.gloop.gameobjects {
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Wall extends DefaultGameObject {
		
		public function Wall(offsetX:Number, offsetY:Number, width:Number, height:Number, worldX:Number = 0, worldY:Number = 0) {
			super();
			_physics = new WallPhysicsComponent(this, offsetX, offsetY, width, height);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.setStatic(true);
		}
		
	}

}


import Box2DAS.Common.V2;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;

class WallPhysicsComponent extends PhysicsComponent {
	
	private var _width:Number;
	private var _height:Number;
	private var _offsetX:Number;
	private var _offsetY:Number;
	
	public function WallPhysicsComponent(gameObject:DefaultGameObject, offsetX:Number, offsetY:Number, width:Number, height:Number) {
		super(gameObject);
		_offsetX = offsetX;
		_offsetY = offsetY;
		_width = width;
		_height = height;
		graphics.beginFill(0x642BA4);
		graphics.drawRect(_offsetX, _offsetY, _width, _height);
	}
	
	public override function shapes():void {
		box(_width, _height, new V2(_width/2  +_offsetX, _height/2 + _offsetY));
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(LEVEL);
	}
	
}