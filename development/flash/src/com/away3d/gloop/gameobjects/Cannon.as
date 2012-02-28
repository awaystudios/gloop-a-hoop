package com.away3d.gloop.gameobjects
{
	import away3d.animators.data.VertexAnimationState;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.DefaultMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.GloopLauncherComponent;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.VertexAnimationComponent;
	import com.away3d.gloop.utils.EmbeddedResources;
	
	import flash.display.Bitmap;
	import flash.utils.setTimeout;

	public class Cannon extends DefaultGameObject implements IMouseInteractive
	{
		private var _animComponent : VertexAnimationComponent;
		private var _cannonBody : Mesh;
		private var _launcher : GloopLauncherComponent;
		
		private var _frame0 : Geometry;
		private var _frame1 : Geometry;
		private var _animState : VertexAnimationState;
		
		private var _timeSinceLaunch : Number = 0;
		
		public function Cannon()
		{
			super();
			
			init();
		}
		
		
		private function init() : void
		{
			initVisual();
			initAnim();
			
			_launcher = new GloopLauncherComponent(this);
			_physics = new CannonPhysicsComponent(this);
		}
		
		
		private function initVisual() : void
		{
			var tex : BitmapTexture;
			var bodyMat : DefaultMaterialBase;
			var footMat : DefaultMaterialBase;
			var footGeom : Geometry;
			var bodyGeom : Geometry;
			
			tex = new BitmapTexture(Bitmap(new EmbeddedResources.CannonDiffusePNGAsset()).bitmapData);
			
			bodyMat = new TextureMaterial(tex);
			footMat = new TextureMaterial(tex);
			
			bodyGeom = Geometry(AssetLibrary.getAsset('CannonFrame0_geom')).clone();
			footGeom = Geometry(AssetLibrary.getAsset('CannonFoot_geom'));
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(footGeom, footMat);
			
			_cannonBody = new Mesh(bodyGeom, bodyMat);
			_meshComponent.mesh.addChild(_cannonBody);
		}
		
		
		private function initAnim() : void
		{
			_frame0 = Geometry(AssetLibrary.getAsset('CannonFrame0_geom'));
			_frame1 = Geometry(AssetLibrary.getAsset('CannonFrame1_geom'));
			
			_animComponent = new VertexAnimationComponent(_cannonBody);
			_animComponent.addSequence('fire', [
				_frame1,
				Geometry(AssetLibrary.getAsset('CannonFrame2_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame3_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame0_geom')),
			], 50, false);
			
			_animState = VertexAnimationState(_cannonBody.animationState);
		}
		
		
		override public function reset():void {
			super.reset();
			_launcher.reset();
			
			_animComponent.stop();
			_animState.poses[0] = _frame0;
			_animState.poses[1] = _frame1;
			_animState.weights[0] = 1;
			_animState.weights[1] = 0;
			
			// set as sensor to disable resolution of gloop collisions
			_physics.isSensor = true;
		}
		
		public function catchGloop(gloop:Gloop):void {
			_launcher.catchGloop(gloop);	
		}
		
		
		public function onClick(mouseX:Number, mouseY:Number):void {
			// do nothing
		}
		
		public function onDragStart(mouseX:Number, mouseY:Number):void {
			// do nothing
		}
		
		public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			if (_launcher.gloop) {
				var pow : Number;
				
				_launcher.onDragUpdate(mouseX, mouseY);
				
				pow = _launcher.dragAmount;
				trace(pow);
				_animState.weights[0] = 1-pow;
				_animState.weights[1] = pow;
				_animState.invalidateState();
			}
		}
		
		public function onDragEnd(mouseX:Number, mouseY:Number):void {
			if (_launcher.gloop) {
				_animComponent.play('fire');
				
				// TODO: Solve this in a nicer way, or at least make sure
				// it can't happen twice in parallel?
				setTimeout(function() : void {
					_launcher.onDragEnd(mouseX, mouseY);
					
					// if the launcher fired this time, reset the time since launch
					if (_launcher.fired) {
						_timeSinceLaunch = 0;
					}
				}, 150);
			}
		}
		
		override public function update(dt : Number) : void
		{
			super.update(dt);
			_launcher.update(dt);
			
			_meshComponent.mesh.rotationZ = 0;
			_cannonBody.rotationZ = 90-_physics.rotation;
			
			// if the launcher has been fired and we're still a sensor
			if (_launcher.fired && _physics.isSensor) {
				
				// if enough time has passed, enable the physics
				_timeSinceLaunch += dt;
				if (_timeSinceLaunch > Settings.CANNON_PHYSICS_DELAY) {
					_physics.isSensor = false;
				}
			}
			
		}
	}
}

import Box2DAS.Common.V2;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.hoops.Hoop;
import com.away3d.gloop.level.Level;
import com.away3d.gloop.Settings;
import flash.utils.setInterval;

class CannonPhysicsComponent extends PhysicsComponent
{
	
	public function CannonPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		//graphics.drawRect( Settings.CANNON_BASE_X, Settings.CANNON_BASE_Y, Settings.CANNON_BASE_W, Settings.CANNON_BASE_H);
		
		graphics.beginFill(gameObject.debugColor2);
		graphics.drawRect( Settings.CANNON_BARREL_X, Settings.CANNON_BARREL_Y, Settings.CANNON_BARREL_W, Settings.CANNON_BARREL_H);
	}
	
	public override function shapes() : void
	{
		// used for gloop collision
		//box(Settings.CANNON_BASE_W, Settings.CANNON_BASE_H, new V2(Settings.CANNON_BASE_W / 2  + Settings.CANNON_BASE_X, Settings.CANNON_BASE_H / 2 + Settings.CANNON_BASE_Y));
		box(Settings.CANNON_BARREL_W, Settings.CANNON_BARREL_H, new V2(Settings.CANNON_BARREL_W / 2  + Settings.CANNON_BARREL_X, Settings.CANNON_BARREL_H / 2 + Settings.CANNON_BARREL_Y));
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(GLOOP_SENSOR, b2fixtures[0]);
		//setCollisionGroup(GLOOP_SENSOR, b2fixtures[1]);
		
		b2fixtures[0].SetSensor(true);
		//b2fixtures[1].SetSensor(true);
		
		allowDragging = true;
		
		setStatic();
	}
}