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

	public class Cannon extends DefaultGameObject
	{
		private var _animComponent : VertexAnimationComponent;
		
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
			var mat : DefaultMaterialBase;
			var geom : Geometry;
			
			mat = new ColorMaterial(0xffcc00);
			geom = Geometry(AssetLibrary.getAsset('CannonFrame0_geom')).clone();
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(geom, mat);
		}
		
		
		private function initAnim() : void
		{
			_animComponent = new VertexAnimationComponent(_meshComponent.mesh);
			_animComponent.addSequence('fire', [
				_meshComponent.mesh.geometry,
				Geometry(AssetLibrary.getAsset('CannonFrame1_geom')).clone(),
				Geometry(AssetLibrary.getAsset('CannonFrame2_geom')).clone(),
				Geometry(AssetLibrary.getAsset('CannonFrame3_geom')).clone(),
			]);
			
			_animComponent.play('fire');
		}
	}
}