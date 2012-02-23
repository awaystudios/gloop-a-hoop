package com.away3d.gloop.gameobjects {
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

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
			
			
			if (Settings.SHOW_COLLISION_WALLS){
				var material:ColorMaterial = new ColorMaterial(debugColor1);
				_meshComponent = new MeshComponent();
				var cube:CubeGeometry = new CubeGeometry(width, height, 60);
				var mtx:Matrix3D = new Matrix3D;
				mtx.appendTranslation(width/2, height/2, 0);
				mtx.appendTranslation(offsetX, -offsetY, 0);
				_meshComponent.mesh = new Mesh(cube, material);
				cube.applyTransformation(mtx);
			}
		}
		
		override public function get debugColor1():uint {
			return 0x642BA4;
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
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawRect(_offsetX, _offsetY - _height, _width, _height);
	}
	
	public override function shapes():void {
		box(_width, _height, new V2(_width/2 + _offsetX, _height/2 + _offsetY - _height));
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(LEVEL);
	}
	
}