package com.away3d.gloop.gameobjects {
	import Box2DAS.Dynamics.ContactEvent;
	
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import com.away3d.gloop.gameobjects.components.GoalWallPhysicsComponent;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.utils.EmbeddedResources;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GoalWall extends Wall {
		
		public function GoalWall(offsetX:Number, offsetY:Number, width:Number, height:Number, worldX:Number = 0, worldY:Number = 0) {
			_physics = new GoalWallPhysicsComponent(this, offsetX, offsetY, width, height);
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
			geom.scale(_physics.height/100);
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(geom, mat);
		}
		
		override public function onCollidingWithGloopStart(gloop:Gloop):void {
			super.onCollidingWithGloopStart(gloop);
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_HIT_GOAL_WALL, this));
			gloop.onHitGoalWall();
		}
		
		public function onGloopEnterSensor(gloop:Gloop):void {
			// gloop goes into sensor
		}
		
		public function onGloopExitSensor(gloop:Gloop):void {
			// gloop leaves sensor
		}
		
		override public function get debugColor1():uint {
			return 0x28a696;
		}
		
	}

}