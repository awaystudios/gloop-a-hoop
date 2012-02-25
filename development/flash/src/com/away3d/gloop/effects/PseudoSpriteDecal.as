package com.away3d.gloop.effects
{

	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;

	import flash.display.BitmapData;

	import flash.display.Sprite;

	public class PseudoSpriteDecal extends Mesh
	{
		public function PseudoSpriteDecal( color:uint = 0xFFFFFF, width:Number = 20, height:Number = 20 ) {

			// produce bitmap data
			var radius:Number = 16;
			var drawDummy:Sprite = new Sprite();
			drawDummy.graphics.beginFill( color );
			drawDummy.graphics.drawCircle( radius, radius, radius );
			drawDummy.graphics.endFill();
			var bmd:BitmapData = new BitmapData( 2 * radius, 2 * radius, true, 0x00FF0000 );
			bmd.draw( drawDummy );
			drawDummy = null;

			// produce bitmap material
			var texture:BitmapTexture = new BitmapTexture( bmd );
			var material:TextureMaterial = new TextureMaterial( texture, false, false, false );
			material.alphaBlending = true;

			super( new PlaneGeometry( width, height ), material );

			rotationX = -90;
		}
	}
}
