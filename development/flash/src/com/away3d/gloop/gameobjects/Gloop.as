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
	import com.away3d.gloop.gameobjects.components.GloopVisualComponent;
	import com.away3d.gloop.gameobjects.components.GloopPhysicsComponent;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PathTraceComponent;
	import com.away3d.gloop.gameobjects.components.SplatComponent;
	import com.away3d.gloop.gameobjects.components.VertexAnimationComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.utils.EmbeddedResources;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.trace.Trace;
	import flash.utils.setInterval;

	public class Gloop extends DefaultGameObject
	{
		private var _splatComponent:SplatComponent;
		private var _traceComponent:PathTraceComponent;
		private var _visualComponent:GloopVisualComponent;
		
		private var _spawnX:Number;
		private var _spawnY:Number;
		
		private var _avgSpeed:Number = 0;
		
		public function Gloop( spawnX:Number, spawnY:Number, traceSpr:Sprite ) {
			super();

			_spawnX = spawnX;
			_spawnY = spawnY;
			
			init();
		}

		private function init():void
		{
			_physics = new GloopPhysicsComponent( this );
			_physics.angularDamping = Settings.GLOOP_ANGULAR_DAMPING;
			_physics.friction = Settings.GLOOP_FRICTION;
			_physics.restitution = Settings.GLOOP_RESTITUTION;
			_physics.linearDamping = Settings.GLOOP_LINEAR_DAMPING;

			_physics.reportPostSolve = true;
			_physics.addEventListener( ContactEvent.POST_SOLVE, contactPostSolveHandler );
			
			// Create special mesh component and use it as
			// mesh component for this default game object
			_visualComponent = new GloopVisualComponent( _physics );
			_meshComponent = _visualComponent;

			_splatComponent = new SplatComponent( _physics );
			_traceComponent = new PathTraceComponent( _physics );
		}
		
		
		public function get traceComponent() : PathTraceComponent
		{
			return _traceComponent;
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

			_splatComponent.reset();
			_visualComponent.reset();
		}
		
		override public function update( dt:Number ):void
		{
			super.update( dt );
			
			var velocity:V2 = _physics.linearVelocity;
			var speed:Number = velocity.length();
			
			_splatComponent.update( dt );
			_traceComponent.update( dt );
			_visualComponent.update( dt, speed, velocity.x );

			if (!inEditMode) {
				_avgSpeed -= (_avgSpeed - speed) * Settings.GLOOP_MOMENTUM_MULTIPLIER;

				if (_avgSpeed < Settings.GLOOP_LOST_MOMENTUM_THRESHOLD) {
					dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_LOST_MOMENTUM, this));
				}
			}
						
		}
		
		private function contactPostSolveHandler( e:ContactEvent ):void
		{
			var force:Number = e.impulses.normalImpulse1 * .1;
			force = Math.min(force, .3);
			
			_visualComponent.bounceAndFaceDirection(-force);
		}
		
		public function splatOnTarget() : void
		{
			_visualComponent.splat();
		}
		
		
		public function onLaunch():void
		{
			_avgSpeed = 10;
			
			_visualComponent.bounceAndFaceDirection(.1);
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_FIRED, this));
			
			_traceComponent.reset();
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

		public function get splatComponent():SplatComponent {
			return _splatComponent;
		}
	}
}
