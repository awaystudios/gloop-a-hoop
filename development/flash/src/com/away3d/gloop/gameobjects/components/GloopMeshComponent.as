package com.away3d.gloop.gameobjects.components
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import com.away3d.gloop.utils.EmbeddedResources;
	
	import flash.display.Bitmap;
	import flash.utils.setInterval;

	public class GloopMeshComponent extends MeshComponent
	{
		public function GloopMeshComponent()
		{
			super();
			
			init();
		}
		
		
		private function init() : void
		{
			var diff_tex : BitmapTexture;
			var spec_tex : BitmapTexture;
			var mat : TextureMaterial;
			var geom:Geometry;
			
			diff_tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopDiffusePNGAsset).bitmapData);
			spec_tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopSpecularPNGAsset).bitmapData);
			
			mat = new TextureMaterial(diff_tex);
			mat.animateUVs = true;
			mat.specularMap = spec_tex;

			geom = Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) );
			
			mesh = new Mesh( geom, mat );
			mesh.subMeshes[0].scaleU = 0.5;
			mesh.subMeshes[0].scaleV = 0.5;
			
			// TODO: Replace with nicer texture animations.
			mat.repeat = true;
			setInterval(function() : void {
				mesh.subMeshes[0].offsetU += 0.5;
			}, 300);
		}
	}
}