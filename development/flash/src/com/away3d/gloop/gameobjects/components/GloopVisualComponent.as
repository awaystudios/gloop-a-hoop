package com.away3d.gloop.gameobjects.components
{
	import Box2DAS.Common.V2;
	
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import com.away3d.gloop.utils.EmbeddedResources;
	
	import flash.display.Bitmap;
	import flash.utils.setInterval;

	public class GloopVisualComponent extends MeshComponent
	{
		private var _physics : PhysicsComponent;
		
		private var _bounceVelocity:Number = 0;
		private var _bouncePosition:Number = 0;
		private var _facingRotation:Number = 0;
		
		public function GloopVisualComponent(physics : PhysicsComponent)
		{
			super();
			
			_physics = physics;
			
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
		
		
		public function reset() : void
		{
			_bounceVelocity = 0;
			_bouncePosition = 0;
		}
		
		
		public function bounceAndFaceDirection(bounceAmount:Number):void{
			var velocity:V2 = _physics.linearVelocity;
			
			if (velocity.length() < 2){
				_facingRotation = 0;
			} else {
				_facingRotation = Math.atan2(velocity.x, velocity.y) / Math.PI * 180 - 180;
			}
			
			_bounceVelocity = bounceAmount;
		}
		
		
		public function update(dt : Number, speed : Number, vx : Number) : void
		{
			_facingRotation -= vx * .25;
			mesh.rotationZ = _facingRotation;
			
			_bounceVelocity -= (_bouncePosition - 0.5) * .1;
			_bounceVelocity *= .8;
			
			_bouncePosition += _bounceVelocity;
			
			speed = Math.min(speed, 3);

			mesh.scaleY = Math.max(.2, .5 + _bouncePosition) + speed * 0.05;
			mesh.scaleX = 1 + (1 - mesh.scaleY)
		}
	}
}