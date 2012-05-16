package com.away3d.gloop.gameobjects {

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;

	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.GoalWallPhysicsComponent;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.utils.EmbeddedResources;

	import flash.display.Bitmap;
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GoalWall extends Wall {
		
		private var _width:Number;
		private var _height:Number;
		private var _splatDistance:Number = 1;
		
		public function GoalWall(offsetX:Number, offsetY:Number, width:Number, height:Number, worldX:Number = 0, worldY:Number = 0) {
			_height = height;
			_width = width;
			_physics = new GoalWallPhysicsComponent(this, offsetX, offsetY, width, height);
			_physics.enableReportBeginContact();
			_physics.enableReportEndContact();
			super(offsetX, offsetY, width, height, worldX, worldY);
			
			initVisual();
		}
		
		private function initVisual() : void
		{
			var geom : Geometry;
			var tex : BitmapTexture;
			var mat : TextureMaterial;
			
			tex = new BitmapTexture(Bitmap(new EmbeddedResources.TargetDiffusePNGAsset).bitmapData);
			mat = new TextureMaterial(tex);
			
			// Diameter of target asset is 100 units. Scale to fit wall
			// size as defined in level.
			geom = Geometry(AssetLibrary.getAsset('Target_geom'));
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(geom, mat);
			_meshComponent.mesh.scale(_physics.width/100);
		}
		
		override public function reset():void {
			super.reset();
			_splatDistance = 1;
		}

		override public function onCollidingWithGloopEnd( gloop:Gloop, event:ContactEvent = null ):void {

			super.onCollidingWithGloopEnd(gloop);
			
			var gloopCenter:V2 = gloop.physics.b2body.GetWorldCenter();
			var wallCenter:V2 = this.physics.b2body.GetWorldCenter();
			
			_splatDistance = gloopCenter.subtract(wallCenter).length();

			// make sure gloop's mesh is touching the target
			var gloopMeshPosition:Vector3D = gloop.meshComponent.mesh.position;
			var targetMeshPosition:Vector3D = this.meshComponent.mesh.position;
			var delta:Vector3D = gloopMeshPosition.subtract( targetMeshPosition );
			var targetNormal:Vector3D = this.meshComponent.mesh.downVector;
			var distance:Number = delta.dotProduct( targetNormal );
			gloop.visualComponent.splatMesh.y = -distance;

			// scale back up to world units
			_splatDistance *= Settings.PHYSICS_SCALE;
			
			// we can never be closer than the walls _height, so we remove that, then divide by the walls width to get a normalized value back
			_splatDistance = (_splatDistance - _height) / (_width / 2);
			
			gloop.splatOnTarget(_physics.rotation);
			gloop.onHitGoalWall();

			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_HIT_GOAL_WALL, this));
		}

		override public function update( dt:Number ):void {
			super.update( dt );
		}

		public function onGloopEnterSensor(gloop:Gloop):void {
			// gloop goes into sensor
			// TODO: Check that velocity is high enough
			gloop.onApproachGoalWall();
		}
		
		public function onGloopExitSensor(gloop:Gloop):void {
			// gloop leaves sensor
			gloop.onMissGoalWall();
		}
		
		override public function get debugColor1():uint {
			return 0x28a696;
		}
		
		/**
		 * Returns a normalized value (0-1) of the distance from the bullseye.
		 */
		public function get splatDistance():Number {
			return _splatDistance;
		}
		
	}

}