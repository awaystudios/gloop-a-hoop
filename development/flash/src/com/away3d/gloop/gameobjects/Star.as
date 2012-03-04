package com.away3d.gloop.gameobjects
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;

	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.VertexAnimationComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.sound.SoundManager;
	import com.away3d.gloop.sound.Sounds;
	
	public class Star extends DefaultGameObject
	{
		private var _animComponent:VertexAnimationComponent;
		private var _touched:Boolean = false;
		private var _randomRotation : Number;
		
		public function Star(worldX:Number = 0, worldY:Number = 0)
		{
			_physics = new StarPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.applyGravity = false;
			_physics.isSensor = true;
			_physics.enableReportBeginContact();
			
			initVisual();
		}
		
		private function initVisual() : void
		{
			var geom : Geometry;
			var mat : ColorMaterial;
			
			geom = Geometry(AssetLibrary.getAsset('StarFrame0_geom')).clone();
			mat = new ColorMaterial(0xccff00);
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(geom, mat);
			
			_animComponent = new VertexAnimationComponent(_meshComponent.mesh);
			_animComponent.addSequence('seq', [
				Geometry(AssetLibrary.getAsset('StarFrame0_geom')),
				Geometry(AssetLibrary.getAsset('StarFrame1_geom')),
				Geometry(AssetLibrary.getAsset('StarFrame2_geom')),
				Geometry(AssetLibrary.getAsset('StarFrame3_geom')),
				Geometry(AssetLibrary.getAsset('StarFrame4_geom')),
			], 600);
			_animComponent.play('seq');
			
		}
		
		override public function reset():void {
			super.reset();
			_touched = false;
			_meshComponent.mesh.visible = true;
			
			_randomRotation = Math.random() * 360;
		}
		
		override public function update(dt:Number):void
		{
			super.update(dt);
			
			_meshComponent.mesh.rotationZ = _randomRotation;
		}
		
		override public function onCollidingWithGloopStart(gloop:Gloop):void {
			super.onCollidingWithGloopStart(gloop);
			if (_touched) return;
			_touched = true;
			_meshComponent.mesh.visible = false;
			
			SoundManager.play(Sounds.GAME_STAR);
			
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_COLLECT_STAR, this));
		}
		
		override public function get debugColor1():uint {
			return 0x01e6f1;
		}
	}
}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.Settings;

class StarPhysicsComponent extends PhysicsComponent
{
	
	public function StarPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawCircle(0, 0, Settings.STAR_RADIUS);
	}
	
	public override function shapes() : void
	{
		circle(Settings.STAR_RADIUS);
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(GLOOP_SENSOR);
	}
}