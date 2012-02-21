package com.away3d.gloop.effects.decals
{

	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;

	import flash.display.BitmapData;

	public class SplatDecal extends Mesh
	{
		public function SplatDecal( bitmapData:BitmapData ) {
			var bitmapTexture:BitmapTexture = new BitmapTexture( bitmapData );
			var textureMaterial:TextureMaterial = new TextureMaterial( bitmapTexture );
			textureMaterial.alphaBlending = true;
			super( new PlaneGeometry( 50, 50 ), textureMaterial );
			rotationX += 90;
			bakeTransformations();
		}
	}
}
