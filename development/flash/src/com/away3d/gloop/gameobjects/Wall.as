package com.away3d.gloop.gameobjects {
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.WallPhysicsComponent;
	import com.away3d.gloop.Settings;
	import flash.geom.Matrix3D;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Wall extends DefaultGameObject {
		
		public function Wall(offsetX:Number, offsetY:Number, width:Number, height:Number, worldX:Number = 0, worldY:Number = 0) {
			super();
			
			if(!_physics) _physics = new WallPhysicsComponent(this, offsetX, offsetY, width, height);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.setStatic(true);
			
			if (Settings.SHOW_COLLISION_WALLS){
				var material:ColorMaterial = new ColorMaterial(debugColor1);
				_meshComponent = new MeshComponent();
				var cube:CubeGeometry = new CubeGeometry(width, height, 60);
				var mtx:Matrix3D = new Matrix3D;
				mtx.appendTranslation(width/2, -height/2, 0);
				mtx.appendTranslation(offsetX, offsetY, 0);
				_meshComponent.mesh = new Mesh(cube, material);
				cube.applyTransformation(mtx);
			}
		}
		
		override public function get debugColor1():uint {
			return 0x642BA4;
		}
		
	}

}