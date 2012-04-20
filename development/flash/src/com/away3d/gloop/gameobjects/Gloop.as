package com.away3d.gloop.gameobjects
{

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import away3d.containers.View3D;

	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.textures.BitmapTexture;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.GloopPhysicsComponent;
	import com.away3d.gloop.gameobjects.components.GloopVisualComponent;
	import com.away3d.gloop.gameobjects.components.PathTraceComponent;
	import com.away3d.gloop.gameobjects.components.SplatComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.sound.SoundManager;
	import com.away3d.gloop.sound.Sounds;
	
	import flash.display.Sprite;

	public class Gloop extends DefaultGameObject
	{
		private var _splatComponent:SplatComponent;
		private var _traceComponent:PathTraceComponent;
		private var _visualComponent:GloopVisualComponent;
		
		private var _spawnX:Number;
		private var _spawnY:Number;
		
		private var _didHit : Boolean;
		
		private var _avgSpeed:Number = 0;

		public function Gloop( spawnX:Number, spawnY:Number ) {
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
			_physics.applyGravity = true;
			_physics.bullet = true;
			_physics.reportPostSolve = true;
			_physics.addEventListener( ContactEvent.POST_SOLVE, contactPostSolveHandler );
			
			// Create special mesh component and use it as
			// mesh component for this default game object
			_visualComponent = new GloopVisualComponent( _physics );
			_meshComponent = _visualComponent;

			_splatComponent = new SplatComponent( _physics );
			_traceComponent = new PathTraceComponent( _physics );
		}

		override public function setLightPicker( picker:LightPickerBase ):void {
			super.setLightPicker( picker );
			_splatComponent.setLightPicker( picker );
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
			
			_didHit = false;
			_physics.setStatic(false);

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
			if (_didHit) {
				_physics.setStatic(true);
			}
			
			super.update( dt );
			
			var velocity:V2 = _physics.linearVelocity;
			var speed:Number = velocity.length();
			
			if (speed > Settings.GLOOP_MAX_SPEED) {
				velocity.normalize(Settings.GLOOP_MAX_SPEED);
				_physics.b2body.SetLinearVelocity(velocity);
			}
			
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
			
			_visualComponent.bounceAndFaceDirection( -force);
			
			// kill any velocity from the contact resolution if we've hit the target
			if (_didHit) {
				_physics.b2body.SetLinearVelocity(new V2);	
			}
		}
		
		public function onApproachGoalWall() : void
		{
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_APPROACH_GOAL_WALL, this));
		}
		
		public function onMissGoalWall() : void
		{
			if (!_didHit)
				dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_MISSED_GOAL_WALL, this));
		}
		
		public function splatOnTarget(angle : Number) : void
		{
			SoundManager.play(Sounds.GAME_SPLAT);
			_visualComponent.splat(angle);
		}
		
		
		public function onLaunch():void
		{
			_avgSpeed = 10;
			
			_visualComponent.bounceAndFaceDirection(.1);
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_FIRED, this));
			
			_traceComponent.reset();
		}

		public function onHitGoalWall():void {
			_didHit = true;
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
