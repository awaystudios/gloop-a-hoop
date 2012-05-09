package com.away3d.gloop.gameobjects {

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;

	import com.away3d.gloop.gameobjects.components.GloopVisualComponent;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.WallPhysicsComponent;
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.sound.SoundManager;
	import com.away3d.gloop.sound.Sounds;

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
			_physics.enableReportBeginContact();

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

		override public function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null ):void {

			super.onCollidingWithGloopStart(gloop);

			var speed:Number = gloop.physics.b2body.GetLinearVelocity().length();
			if( speed > 1 ) {
				SoundManager.playRandom( Sounds.GLOOP_WALL_HIT_1, Sounds.GLOOP_WALL_HIT_2, Sounds.GLOOP_WALL_HIT_3, Sounds.GLOOP_WALL_HIT_4 );
				gloop.visualComponent.setFacial( GloopVisualComponent.FACIAL_OUCH );
			}

		}
		
		override public function get debugColor1():uint {
			return 0x642BA4;
		}
		
	}

}