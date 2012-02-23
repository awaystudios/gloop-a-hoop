package com.away3d.gloop.gameobjects
{

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.SplatComponent;
	import com.away3d.gloop.gameobjects.components.VertexAnimationComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.setInterval;

	public class Gloop extends DefaultGameObject
	{
		private var _anim:VertexAnimationComponent;

		private var _splat:SplatComponent;
		private var _spawnX:Number;
		private var _spawnY:Number;

		private var _avgSpeed:Number = 0;

		private var _bounceVelocity:Number = 0;
		private var _bouncePosition:Number = 0;
		private var _facingRotation:Number = 0;
		
		[Embed("/../assets/gloop/diff.png")]
		private var GloopDiffusePNGAsset : Class;

		[Embed("/../assets/gloop/spec.png")]
		private var GloopSpecularPNGAsset : Class;

		public function Gloop( spawnX:Number, spawnY:Number, traceSpr:Sprite ) {
			super();

			_spawnX = spawnX;
			_spawnY = spawnY;
			
			init();
		}

		private function init():void {
			_physics = new GloopPhysicsComponent( this );
			_physics.angularDamping = Settings.GLOOP_ANGULAR_DAMPING;
			_physics.friction = Settings.GLOOP_FRICTION;
			_physics.restitution = Settings.GLOOP_RESTITUTION;
			_physics.linearDamping = Settings.GLOOP_LINEAR_DAMPING;

			_splat = new SplatComponent( _physics );

			_physics.reportPostSolve = true;
			_physics.addEventListener( ContactEvent.POST_SOLVE, contactPostSolveHandler );

			initVisual();
			initAnim();
		}
		
		
		private function initVisual():void
		{
			var diff_tex : BitmapTexture;
			var spec_tex : BitmapTexture;
			var mat : TextureMaterial;
			var geom:Geometry;
			
			diff_tex = new BitmapTexture(Bitmap(new GloopDiffusePNGAsset).bitmapData);
			spec_tex = new BitmapTexture(Bitmap(new GloopSpecularPNGAsset).bitmapData);
			
			mat = new TextureMaterial(diff_tex);
			mat.animateUVs = true;
			mat.specularMap = spec_tex;

			geom = Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) );
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh( geom, mat );
			_meshComponent.mesh.subMeshes[0].scaleU = 0.5;
			_meshComponent.mesh.subMeshes[0].scaleV = 0.5;
			
			// TODO: Replace with nicer texture animations.
			mat.repeat = true;
			setInterval(function() : void {
				_meshComponent.mesh.subMeshes[0].offsetU += 0.5;
			}, 300);
		}
		
		private function initAnim():void
		{
			_anim = new VertexAnimationComponent( _meshComponent.mesh );
			_anim.addSequence( 'fly', [
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame1Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame2Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame3Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame4Geom' ) )
			] );

		}
		
		
		public function setSpawn(x : Number, y : Number) : void
		{
			_spawnX = x;
			_spawnY = y;
		}
		

		override public function reset():void {
			super.reset();

			_physics.x = _spawnX,
			_physics.y = _spawnY;
			if( _physics.b2body ) {
				_physics.syncTransform();
				_physics.b2body.SetAngularVelocity( 0 );
				_physics.b2body.SetLinearVelocity( new V2( 0, 0 ) );
			}

			_bounceVelocity = 0;
			_bouncePosition = 0;

			_splat.reset();
		}
		
		override public function update( dt:Number ):void {

			super.update( dt );
			_splat.update( dt );
			
			var velocity:V2 = _physics.linearVelocity;
			var speed:Number = velocity.length();

			if (!inEditMode) {
				_avgSpeed -= (_avgSpeed - speed) * Settings.GLOOP_MOMENTUM_MULTIPLIER;

				if (_avgSpeed < Settings.GLOOP_LOST_MOMENTUM_THRESHOLD) {
					dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_LOST_MOMENTUM, this));
				}
			}
						
			_facingRotation -= velocity.x * .25;
			_meshComponent.mesh.rotationZ = _facingRotation;
			
			_bounceVelocity -= (_bouncePosition - 0.5) * .1;
			_bounceVelocity *= .8;
			
			_bouncePosition += _bounceVelocity;
			
			speed = Math.min(speed, 3);

			_meshComponent.mesh.scaleY = Math.max(.2, .5 + _bouncePosition) + speed * 0.05;
			_meshComponent.mesh.scaleX = 1 + (1 - _meshComponent.mesh.scaleY)
		}
		
		private function contactPostSolveHandler( e:ContactEvent ):void {
			var force:Number = e.impulses.normalImpulse1 * .1;
			force = Math.min(force, .3);
			bounceAndFaceDirection(-force);
		}
		
		private function bounceAndFaceDirection(bounceAmount:Number):void{
			var velocity:V2 = _physics.linearVelocity;
			
			if (velocity.length() < 2){
				_facingRotation = 0;
			} else {
				_facingRotation = Math.atan2(velocity.x, velocity.y) / Math.PI * 180 - 180;
			}
			
			_bounceVelocity = bounceAmount;
		}
		
		public function onLaunch():void {
			_avgSpeed = 10;
			bounceAndFaceDirection(.1);
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_FIRED, this));
		}

		public function onHitGoalWall():void {
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_HIT_GOAL_WALL, this));
		}

		override public function get debugColor1():uint {
			return 0x84c806;
		}

		override public function get debugColor2():uint {
			return 0x7da628;
		}

		public function get splat():SplatComponent {
			return _splat;
		}
	}
}

import com.away3d.gloop.Settings;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;

class GloopPhysicsComponent extends PhysicsComponent
{

	public function GloopPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );

		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawCircle( 0, 0, Settings.GLOOP_RADIUS );
		graphics.beginFill( gameObject.debugColor2 );
		graphics.drawRect( -Settings.GLOOP_RADIUS / 2, -Settings.GLOOP_RADIUS / 2, Settings.GLOOP_RADIUS, Settings.GLOOP_RADIUS );
	}
	
	public override function shapes():void {
		circle( Settings.GLOOP_RADIUS );
	}

	override public function create():void {
		super.create();
		setCollisionGroup( GLOOP );
	}
}