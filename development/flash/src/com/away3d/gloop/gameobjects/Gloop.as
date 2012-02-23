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
	import flash.geom.Vector3D;
	import flash.utils.setInterval;

	public class Gloop extends DefaultGameObject
	{
		private var _anim:VertexAnimationComponent;

		private var _innerMesh:Mesh;
		private var _tracer:Sprite;

		private var _splat:SplatComponent;
		private var _spawnX:Number;
		private var _spawnY:Number;

		private var _avgSpeed:Number = 0;

		private var _bounceVelocity:Vector3D = new Vector3D();
		private var _bouncePosition:Vector3D = new Vector3D();
		
		[Embed("/../assets/gloop/diff.png")]
		private var GloopDiffusePNGAsset : Class;

		[Embed("/../assets/gloop/spec.png")]
		private var GloopSpecularPNGAsset : Class;

		public function Gloop( spawnX:Number, spawnY:Number, traceSpr:Sprite ) {

			super();

			_spawnX = spawnX;
			_spawnY = spawnY;

			// TODO: remove tracer
			_tracer = new Sprite();
			_tracer.graphics.beginFill( 0x00FF00 );
			_tracer.graphics.drawCircle( 0, 0, 5 );
			_tracer.graphics.endFill();
			traceSpr.addChild( _tracer );

			init();
		}

		private function init():void {
			_physics = new GloopPhysicsComponent( this );
			_physics.angularDamping = Settings.GLOOP_ANGULAR_DAMPING;
			_physics.friction = Settings.GLOOP_FRICTION;
			_physics.restitution = Settings.GLOOP_RESTITUTION;

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
			_innerMesh = new Mesh( geom, mat );
			_innerMesh.subMeshes[0].scaleU = 0.5;
			_innerMesh.subMeshes[0].scaleV = 0.5;

			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh();
			_meshComponent.mesh.addChild( _innerMesh );
			
			// TODO: Replace with nicer texture animations.
			mat.repeat = true;
			setInterval(function() : void {
				_innerMesh.subMeshes[0].offsetU += 0.5;
			}, 300);
		}
		
		private function initAnim():void
		{
			_anim = new VertexAnimationComponent( _innerMesh );
			_anim.addSequence( 'fly', [
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame1Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame2Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame3Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame4Geom' ) )
			] );

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

			_bounceVelocity = new Vector3D();
			_bouncePosition = new Vector3D();

			_anim.play( 'fly' );
		}

		private function contactPostSolveHandler( event:ContactEvent ):void {
			var collisionStrength:Number = event.impulses.normalImpulse1;
			var collisionNormal:Vector3D = new Vector3D( event.normal.x, event.normal.y, 0 );
			collisionNormal = _innerMesh.sceneTransform.deltaTransformVector( collisionNormal );
			collisionNormal.normalize(); // TODO: need normalize?
			var force:Number = collisionStrength * BOUNCINESS_IMPACT_DISPLACEMENT;
			_bouncePosition.x += force * Math.abs( collisionNormal.x ); // use force to alter spring position
			_bouncePosition.y += force * Math.abs( collisionNormal.y );
		}

		// TODO: move all bounce code out of here!
		private const BOUNCINESS_IMPACT_DISPLACEMENT:Number = 0.2;
		private const BOUNCINESS_SPRING_FORCE:Number = 0.25;
		private const BOUNCINESS_DAMPENING:Number = 0.75;
		private const BOUNCINESS_EFFECT_ON_SCALE_X:Number = 0.5;
		private const BOUNCINESS_EFFECT_ON_SCALE_Y:Number = 0.5;
		private const ALIGNMENT_VELOCITY_FACTOR:Number = 0.2;
		private const ALIGNMENT_RESTORE_FACTOR:Number = 0.01;

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

			// update inner mesh orientation depending on velocity
			if( speed > 0 ) {
				var flyTorque:Number = velocity.x;
				_physics.b2body.ApplyTorque( flyTorque * ALIGNMENT_VELOCITY_FACTOR ); // align towards horizontal trajectory
			}
			_physics.b2body.ApplyTorque( _meshComponent.mesh.rotationZ * ALIGNMENT_RESTORE_FACTOR ); // tend to point upwards

			// bounce
			var distance:Number = _bouncePosition.length; // apply spring acceleration
			if( distance > 0 ) {
				var force:Number = distance * BOUNCINESS_SPRING_FORCE;
				_bounceVelocity.x -= force * _bouncePosition.x / distance;
				_bounceVelocity.y -= force * _bouncePosition.y / distance;
			}
			_bounceVelocity.x *= BOUNCINESS_DAMPENING; // dampen velocity
			_bounceVelocity.y *= BOUNCINESS_DAMPENING;
			_bouncePosition.x += _bounceVelocity.x; // update position
			_bouncePosition.y += _bounceVelocity.y;
			_innerMesh.scaleX = 1 - _bouncePosition.x * BOUNCINESS_EFFECT_ON_SCALE_X; // apply scale
			_innerMesh.scaleY = 1 - _bouncePosition.y * BOUNCINESS_EFFECT_ON_SCALE_Y;

			// TODO: remove tracer
			if( _tracer.stage ) {
				_tracer.x = -400 + _tracer.stage.stageWidth / 2 + 50 * _bouncePosition.x;
				_tracer.y = 300 + _tracer.stage.stageHeight / 2 + 50 * _bouncePosition.y;
			}
		}
		
		public function onLaunch():void {
			_avgSpeed = 10;
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