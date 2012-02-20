package com.away3d.gloop.camera
{

	import flash.display.Stage;

	public class XYCameraController extends CameraControllerBase implements ICameraController
	{
		public function XYCameraController() {
			super();
		}

		override public function set stage( value:Stage ):void {
			super.stage = value;
		}

		override public function dispose():void {
		}

		override public function update():void {
			_camera.x = _stage.mouseX - _stage.stageWidth / 2;
			_camera.y = _stage.mouseY - _stage.stageHeight / 2;
		}
	}
}
