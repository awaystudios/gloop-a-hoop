package com.away3d.gloop.input
{

	import away3d.containers.View3D;

	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	/*
		 * Translates 3D view mouse interactions to 2D physics view mouse interactions.
		 * */
	public class MouseManager
	{
		private var _view:View3D;
		private var _planeNormal:Vector3D;
		private var _planeD:Number;
		private var _intersection:Vector3D;
		
		protected var _mouseDown:Boolean = false;

		private const PLANE_POSITION:Vector3D = new Vector3D( 0, 0, -50 );

		public function MouseManager(view:View3D) {
			_view = view;
			_view.addEventListener( MouseEvent.MOUSE_DOWN, onViewMouseDown );
			_view.addEventListener( MouseEvent.MOUSE_UP, onViewMouseUp );
			
			_planeNormal = new Vector3D( 0, 0, -1 );
			_planeD = -_planeNormal.dotProduct( PLANE_POSITION );
			_intersection = new Vector3D();
		}

		public function update():void {
			//if (!_mouseDown) return;	// if there's no touch, there's no sense in updating
			evaluateMouseRayIntersection();
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
		
		protected function onViewMouseDown(e:MouseEvent):void {
			_mouseDown = true;
		}
		
		protected function onViewMouseUp(e:MouseEvent):void {
			_mouseDown = false;
		}
		
		public function get mouseX():Number{
			return _intersection.x;
		}
		
		public function get mouseY():Number{
			return -_intersection.y;
		}
			
		public function get mouseDown():Boolean {
			return _mouseDown;
		}
	}
}
