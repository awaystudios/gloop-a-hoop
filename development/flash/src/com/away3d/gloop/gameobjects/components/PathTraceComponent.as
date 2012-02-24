package com.away3d.gloop.gameobjects.components
{

	import Box2DAS.Common.V2;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.events.Object3DEvent;
	
	import com.away3d.gloop.effects.PathTracer;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class PathTraceComponent
	{
		private var _physics:PhysicsComponent;
		private var _pathTracer:PathTracer;
		private var _time:Number = 0;
		
		private var _lastPosX : Number;
		private var _lastPosY : Number;
		

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
			_lastPosX = _physics.x;
			_lastPosY = _physics.y;
		}


		private const TRACE_MIN_DTIME : Number = 1;
		private const TRACE_MIN_DPOS_SQUARED : Number = 100;

		public function update( dt:Number ):void {
			if (_pathTracer.hasMore) {
				_time += dt;
				if( _time > TRACE_MIN_DTIME ) {
					var speed:Number = _physics.linearVelocity.length();
					if( speed > 0 ) {
						var dx : Number, dy : Number;
						var dSquared : Number;
						
						dx = _physics.x - _lastPosX;
						dy = _physics.y - _lastPosY;
						dSquared = dx*dx + dy*dy;
						
						if( dSquared > TRACE_MIN_DPOS_SQUARED ) {
							_pathTracer.tracePoint( _physics.x, -_physics.y, 0 );
							
							_lastPosX = _physics.x;
							_lastPosY = _physics.y;
						}
					}
					
					_time = 0;
				}
			}
		}
	}
}
