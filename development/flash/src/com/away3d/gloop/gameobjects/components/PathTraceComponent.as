package com.away3d.gloop.gameobjects.components
{

	import Box2DAS.Common.V2;

	import away3d.events.Object3DEvent;

	import com.away3d.gloop.effects.PathTracer;

	import flash.events.Event;

	public class PathTraceComponent
	{
		private var _physics:PhysicsComponent;
		private var _pathTracer:PathTracer;
		private var _time:Number = 0;
		private var _lastPosition:V2 = new V2();

		public function PathTraceComponent( physics:PhysicsComponent ) {

			_physics = physics;

			_pathTracer = new PathTracer();

			var meshComponent:MeshComponent = physics.gameObject.meshComponent;
			if( meshComponent ) {
				meshComponent.mesh.addEventListener( Object3DEvent.SCENE_CHANGED, meshAddedToSceneHandler );
			}
		}

		private function meshAddedToSceneHandler( event:Event ):void {
			var meshComponent:MeshComponent = _physics.gameObject.meshComponent;
			if( meshComponent && meshComponent.mesh.scene ) {
				meshComponent.mesh.scene.addChild( _pathTracer );
			}
		}

		public function startNewPath():void {
			_pathTracer.createNewPath();
		}

		public function deleteLastPath():void {
			if( _pathTracer.numPaths > 1 ) {
				_pathTracer.deletePath( 0 );
			}
		}

		public function deleteAllPaths():void {
			while( _pathTracer.numPaths > 0 ) {
				_pathTracer.deletePath( 0 );
			}
		}

		private const TIME_STEP:Number = 1;
		private const PLACEMENT_OFFSET:Number = 10;

		public function update( dt:Number ):void {
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
