package com.away3d.gloop.camera
{

	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class MouseKeyboardCameraController extends CameraControllerBase
	{
		private var _mouseIsDown:Boolean;
		private var _keysDown:Dictionary;

		public function MouseKeyboardCameraController() {
			super();
			_keysDown = new Dictionary();
		}

		public function mouseIsDown():Boolean {
			return _mouseIsDown;
		}

		public function keyIsDown( keyCode:uint ):Boolean {
			return _keysDown[ keyCode ];
		}

		override public function set stage( value:Stage ):void {
			super.stage = value;
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, stageKeyDownHandler );
			_stage.addEventListener( KeyboardEvent.KEY_UP, stageKeyUpHandler );
			_stage.addEventListener( MouseEvent.MOUSE_DOWN, stageMouseDownHandler );
			_stage.addEventListener( MouseEvent.MOUSE_UP, stageMouseUpHandler );
		}

		override public function dispose():void {
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, stageKeyDownHandler );
			_stage.removeEventListener( KeyboardEvent.KEY_UP, stageKeyUpHandler );
			_stage.removeEventListener( MouseEvent.MOUSE_DOWN, stageMouseDownHandler );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouseUpHandler );
			_keysDown = null;
		}

		private function stageKeyUpHandler( event:KeyboardEvent ):void {
			_keysDown[ event.keyCode ] = false;
		}

		private function stageKeyDownHandler( event:KeyboardEvent ):void {
			_keysDown[ event.keyCode ] = true;
		}

		private function stageMouseUpHandler( event:MouseEvent ):void {
			_mouseIsDown = false;
		}

		private function stageMouseDownHandler( event:MouseEvent ):void {
			_mouseIsDown = true;
		}
	}
}
