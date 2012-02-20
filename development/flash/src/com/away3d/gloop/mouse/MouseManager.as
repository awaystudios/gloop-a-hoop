package com.away3d.gloop.mouse
{

	import away3d.containers.View3D;

	import com.away3d.gloop.level.Level;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import flash.geom.Vector3D;

	/*
	 * Translates 3D view mouse interactions to 2D physics view mouse interactions.
	 * */
	public class MouseManager extends Sprite
	{
		private var _view:View3D;
		private var _level:Level;
		private var _planeNormal:Vector3D;
		private var _planeD:Number;
		private var _intersection:Vector3D;
		private var _unprojectedMousePosition:Point;
		private var _pointTracer:Sprite;

		private const PLANE_POSITION:Vector3D = new Vector3D( 0, 0, -50 );

		public function MouseManager() {
			_planeNormal = new Vector3D( 0, 0, -1 );
			_planeD = -_planeNormal.dotProduct( PLANE_POSITION );
			_intersection = new Vector3D();
			_unprojectedMousePosition = new Point();
			_pointTracer = new Sprite();
			_pointTracer.graphics.beginFill(0x00FF00);
			_pointTracer.graphics.drawCircle(0, 0, 5);
			_pointTracer.graphics.endFill();
			addChild( _pointTracer );
		}

		public function update():void {
			evaluateMouseRayIntersection(); // TODO: only update on mouse down?
			_unprojectedMousePosition.x = _intersection.x;
			_unprojectedMousePosition.y = -_intersection.y;
			_level.world.unprojectedMousePosition = _unprojectedMousePosition;
		}

		public function set view( value:View3D ):void {
			_view = value;
			_view.addEventListener( MouseEvent.MOUSE_DOWN, viewMouseDownHandler );
		}

		private function viewMouseDownHandler( event:MouseEvent ):void {
			// find mouse event's display object
			var pointInStage:Point = _level.world.localToGlobal( _unprojectedMousePosition );
			_pointTracer.x = pointInStage.x;
			_pointTracer.y = pointInStage.y;
			var objectsUnderPoint:Array = _level.world.stage.getObjectsUnderPoint( pointInStage );
			if( objectsUnderPoint.length == 0 ) return;
			var displayObject:DisplayObject = objectsUnderPoint[ 0 ] as DisplayObject;
			// produce new mouse event
			var physicsEvent:PhysicsMouseEvent = new PhysicsMouseEvent( PhysicsMouseEvent.PHYSICS_MOUSE_EVENT, event.bubbles, event.cancelable,
					event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta );
			physicsEvent.displayObject = displayObject;
			// channel mouse event to physics
			_level.world.handleDragStart( physicsEvent );
		}

		public function set level( value:Level ):void {
			_level = value;
		}

		private function evaluateMouseRayIntersection():void {
			// cast a ray from the camera
			var rayPosition:Vector3D = _view.camera.position;
			var rayDirection:Vector3D = _view.unproject( _view.mouseX, _view.mouseY );
			// evaluate plane intersection
			var planeNormalDotRayPosition:Number = _planeNormal.dotProduct( rayPosition );
			var planeNormalDotRayDirection:Number = _planeNormal.dotProduct( rayDirection );
			var t:Number = -( planeNormalDotRayPosition + _planeD ) / planeNormalDotRayDirection;
			_intersection.x = rayPosition.x + t * rayDirection.x;
			_intersection.y = rayPosition.y + t * rayDirection.y;
			_intersection.z = rayPosition.z + t * rayDirection.z;
		}

		public function get intersection():Vector3D {
			return _intersection;
		}
	}
}
