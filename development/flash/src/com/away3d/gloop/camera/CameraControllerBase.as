package com.away3d.gloop.camera
{

	import away3d.cameras.Camera3D;
	import away3d.errors.AbstractMethodError;

	import flash.display.DisplayObject;
	import flash.display.Stage;

	public class CameraControllerBase
	{
		protected var _camera:Camera3D;
		protected var _context:DisplayObject;

		public function CameraControllerBase() {
		}

		public function dispose():void {
			throw new AbstractMethodError();
		}

		public function update():void {
			throw new AbstractMethodError();
		}

		public function get camera():Camera3D {
			return _camera;
		}

		public function set camera( value:Camera3D ):void {
			_camera = value;
		}

		public function get context():DisplayObject {
			return _context;
		}

		public function set context( value:DisplayObject ):void {
			_context = value;
		}
	}
}
