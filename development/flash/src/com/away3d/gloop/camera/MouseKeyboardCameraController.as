package com.away3d.gloop.camera
{

	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class MouseKeyboardCameraController extends CameraControllerBase
	{
		private var _mouseIsDown:Boolean;
		private var _keysDown:Dictionary;
		protected var _lastMousePosition:Point;

		public function MouseKeyboardCameraController() {
			super();
			_keysDown = new Dictionary();
			_lastMousePosition = new Point();
		}

		public function mouseIsDown():Boolean {
			return _mouseIsDown;
		}

		public function keyIsDown( keyCode:uint ):Boolean {
			return _keysDown[ keyCode ];
		}

		override public function set context( value:DisplayObject ):void {
			super.context = value;
			_context.addEventListener( KeyboardEvent.KEY_DOWN, stageKeyDownHandler );
			_context.addEventListener( KeyboardEvent.KEY_UP, stageKeyUpHandler );
			_context.addEventListener( MouseEvent.MOUSE_DOWN, stageMouseDownHandler );
			_context.addEventListener( MouseEvent.MOUSE_UP, stageMouseUpHandler );
		}

		override public function dispose():void {
			_context.removeEventListener( KeyboardEvent.KEY_DOWN, stageKeyDownHandler );
			_context.removeEventListener( KeyboardEvent.KEY_UP, stageKeyUpHandler );
			_context.removeEventListener( MouseEvent.MOUSE_DOWN, stageMouseDownHandler );
			_context.removeEventListener( MouseEvent.MOUSE_UP, stageMouseUpHandler );
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
			var mouseX:Number = context.mouseX - context.width / 2;
			var mouseY:Number = context.mouseY - context.height / 2;
			_lastMousePosition.x = mouseX;
			_lastMousePosition.y = mouseY;
			_mouseIsDown = true;
		}
	}
}
