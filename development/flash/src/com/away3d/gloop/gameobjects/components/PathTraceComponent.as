package com.away3d.gloop.gameobjects.components
{

	import Box2DAS.Common.V2;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.events.Object3DEvent;
	
	import com.away3d.gloop.effects.PathTracer;
	
	import flash.events.Event;

	public class PathTraceComponent
	{
		private var _physics:PhysicsComponent;
		private var _pathTracer:PathTracer;
		private var _time:Number = 0;
		private var _lastPosition:V2 = new V2();

		public function PathTraceComponent(physics:PhysicsComponent) {

			_physics = physics;
			_pathTracer = new PathTracer();
		}
		
		
		public function get pathTracer() : PathTracer
		{
			return _pathTracer;
		}

		public function reset() : void
		{
			_pathTracer.reset();
		}


		private const TIME_STEP:Number = 1;
		private const PLACEMENT_OFFSET:Number = 10;

		public function update( dt:Number ):void {
			if (_pathTracer.hasMore) {
				_time += dt;
				if( _time > TIME_STEP ) {
					var speed:Number = _physics.linearVelocity.length();
					if( speed > 0 ) {
						var position:V2 = new V2( _physics.x, _physics.y );
						var distance:Number = new V2( position.x - _lastPosition.x, position.y - _lastPosition.y ).length();
						if( distance > PLACEMENT_OFFSET ) {
							_pathTracer.tracePoint( _physics.x, -_physics.y, 0 );
							_lastPosition = position.clone();
						}
					}
					_time = 0;
				}
			}
		}
	}
}
