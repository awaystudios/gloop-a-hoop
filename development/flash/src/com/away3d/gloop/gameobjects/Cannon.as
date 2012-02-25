package com.away3d.gloop.gameobjects
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.DefaultMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import com.away3d.gloop.gameobjects.components.GloopLauncherComponent;
	
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.VertexAnimationComponent;
	import com.away3d.gloop.utils.EmbeddedResources;
	
	import flash.display.Bitmap;

	public class Cannon extends DefaultGameObject
	{
		private var _animComponent : VertexAnimationComponent;
		private var _cannonBody : Mesh;
		private var _launcher : GloopLauncherComponent;
		
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
			_animComponent = new VertexAnimationComponent(_cannonBody);
			_animComponent.addSequence('fire', [
				Geometry(AssetLibrary.getAsset('CannonFrame0_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame1_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame2_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame3_geom')),
			]);
			
			_animComponent.play('fire');
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
		graphics.drawRect( Settings.CANNON_BASE_X, Settings.CANNON_BASE_Y, Settings.CANNON_BASE_W, Settings.CANNON_BASE_H);
		
		graphics.beginFill(gameObject.debugColor2);
		graphics.drawRect( Settings.CANNON_BARREL_X, Settings.CANNON_BARREL_Y, Settings.CANNON_BARREL_W, Settings.CANNON_BARREL_H);
	}
	
	public override function shapes() : void
	{
		// used for gloop collision
		box(Settings.CANNON_BASE_W, Settings.CANNON_BASE_H, new V2(Settings.CANNON_BASE_W / 2  + Settings.CANNON_BASE_X, Settings.CANNON_BASE_H / 2 + Settings.CANNON_BASE_Y));
		box(Settings.CANNON_BARREL_W, Settings.CANNON_BARREL_H, new V2(Settings.CANNON_BARREL_W / 2  + Settings.CANNON_BARREL_X, Settings.CANNON_BARREL_H / 2 + Settings.CANNON_BARREL_Y));
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(LEVEL, b2fixtures[0]);
		setCollisionGroup(LEVEL, b2fixtures[1]);
		
		allowDragging = true;
	}
}