package com.away3d.gloop.gameobjects.components
{
	import Box2DAS.Common.V2;
	
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.primitives.CubeGeometry;
	import away3d.textures.BitmapTexture;
	
	import com.away3d.gloop.utils.EmbeddedResources;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.setInterval;

	public class GloopVisualComponent extends MeshComponent
	{
		private var _physics : PhysicsComponent;
		
		private var _stdAnim : VertexAnimationComponent;
		private var _splatAnim : VertexAnimationComponent;
		
		private var _stdMesh : Mesh;
		private var _splatMesh : Mesh;
		
		private var _bounceVelocity:Number = 0;
		private var _bouncePosition:Number = 0;
		private var _facingRotation:Number = 0;
		
		private var _splatAngle : Number;
		private var _splatting : Boolean;
		
		
		public function GloopVisualComponent(physics : PhysicsComponent)
		{
			super();
			
			_physics = physics;
			
			init();
		}
		
		
		private function init() : void
		{
			// Will be used as container for either
			// standard or splat mesh.
			mesh = new Mesh();
			
			initStandard();
			initSplat();
		}
		
		
		private function initStandard() : void
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
			
			_stdMesh = new Mesh(geom, mat);
			_stdMesh.subMeshes[0].scaleU = 0.5;
			_stdMesh.subMeshes[0].scaleV = 0.5;
			mesh.addChild(_stdMesh);
			
			// TODO: Replace with nicer texture animations.
			mat.repeat = true;
			setInterval(function() : void {
				_stdMesh.subMeshes[0].offsetU += 0.5;
			}, 300);
			
			_stdAnim = new VertexAnimationComponent( _stdMesh );
			_stdAnim.addSequence( 'fly', [
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame1Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame2Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame3Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame4Geom' ) )
			] );
		}
		
		
		private function initSplat() : void
		{
			var tex : BitmapTexture;
			var mat : TextureMaterial;
			var geom : Geometry;
			
			tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopSplatDiffusePNGAsset).bitmapData);
			mat = new TextureMaterial(tex);
			
			geom = Geometry(AssetLibrary.getAsset('GlSplatFr0_geom'));
			
			_splatMesh = new Mesh(geom, mat);
			_splatMesh.y = -10;
			mesh.addChild(_splatMesh);
			
			_splatAnim = new VertexAnimationComponent(_splatMesh);
			_splatAnim.addSequence( 'splat', [
				Geometry(AssetLibrary.getAsset('GlSplatFr0_geom')),
				Geometry(AssetLibrary.getAsset('GlSplatFr1_geom')),
				Geometry(AssetLibrary.getAsset('GlSplatFr2_geom')),
				Geometry(AssetLibrary.getAsset('GlSplatFr3_geom')),
				Geometry(AssetLibrary.getAsset('GlSplatFr4_geom')),
				Geometry(AssetLibrary.getAsset('GlSplatFr3_geom')),
				Geometry(AssetLibrary.getAsset('GlSplatFr4_geom'))
			], 100, false);
		}
		
		
		public override function setLightPicker(picker:LightPickerBase):void
		{
			_stdMesh.material.lightPicker = picker;
			_splatMesh.material.lightPicker = picker;
		}
		
		
		public function splat(angle : Number) : void
		{
			_stdMesh.visible = false;
			_splatMesh.visible = true;
			
			_splatAnim.play('splat');
			
			_splatAngle = angle;
			_splatting = true;
		}
		
		
		public function reset() : void
		{
			_splatMesh.visible = false;
			_stdMesh.visible = true;
			
			_bounceVelocity = 0;
			_bouncePosition = 0;
			_splatting = false;
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
			if (_splatting) {
				mesh.rotationZ = _splatAngle;
			}
			else {
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
}