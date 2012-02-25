package com.away3d.gloop.gameobjects
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.DefaultMaterialBase;
	import away3d.primitives.CubeGeometry;
	
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.VertexAnimationComponent;
	
	import flash.utils.setTimeout;

	public class Cannon extends DefaultGameObject
	{
		private var _animComponent : VertexAnimationComponent;
		
		private var _cannonBody : Mesh;
		
		public function Cannon()
		{
			super();
			
			init();
		}
		
		
		private function init() : void
		{
			initVisual();
			initAnim();
		}
		
		
		private function initVisual() : void
		{
			var bodyMat : DefaultMaterialBase;
			var footMat : DefaultMaterialBase;
			var footGeom : Geometry;
			var bodyGeom : Geometry;
			
			bodyMat = new ColorMaterial(0xffcc00);
			footMat = new ColorMaterial(0x00ffcc);
			
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