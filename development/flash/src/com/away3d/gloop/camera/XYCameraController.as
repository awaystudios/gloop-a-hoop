package com.away3d.gloop.camera
{

	import flash.display.DisplayObject;

	public class XYCameraController extends CameraControllerBase implements ICameraController
	{
		public function XYCameraController() {
			super();
		}

		override public function set context( value:DisplayObject ):void {
			super.context = value;
		}

		override public function dispose():void {
		}

		override public function update():void {
			_camera.x = context.mouseX - context.width / 2;
			_camera.y = context.mouseY - context.height / 2;
		}
	}
}
