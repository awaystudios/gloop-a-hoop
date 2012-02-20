package com.away3d.gloop.camera
{

	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;

	import flash.geom.Point;
	import flash.ui.Keyboard;


	public class FreeFlyCameraController extends MouseKeyboardCameraController implements ICameraController
	{
		private var _lastMousePosition:Point;
		private var _cameraDummy:ObjectContainer3D;

		public var linearEase:Number = 0.25;
		public var angularEase:Number = 0.25;
		public var keyboardMoveSpeed:Number = 50;
		public var mouseDragFactor:Number = 0.05;

		public function FreeFlyCameraController() {
			super();
			_cameraDummy = new ObjectContainer3D();
			_lastMousePosition = new Point();
		}

		override public function set camera( camera:Camera3D ):void {
			super.camera = camera;
			_cameraDummy.transform = camera.transform.clone();
		}

		override public function update():void {
			if( mouseIsDown() ) {
				var mouseX:Number = _stage.mouseX - _stage.stageWidth / 2;
				var mouseY:Number = _stage.mouseY - _stage.stageHeight / 2;
				rotateY( ( mouseX - _lastMousePosition.x ) * mouseDragFactor );
				rotateX( ( mouseY - _lastMousePosition.y ) * mouseDragFactor );
				_lastMousePosition.x = mouseX;
				_lastMousePosition.y = mouseY;
			}
			// keyboard input
			if( keyIsDown( Keyboard.W ) || keyIsDown( Keyboard.UP ) ) moveZ( keyboardMoveSpeed );
			if( keyIsDown( Keyboard.S ) || keyIsDown( Keyboard.DOWN ) ) moveZ( -keyboardMoveSpeed );
			if( keyIsDown( Keyboard.D ) || keyIsDown( Keyboard.RIGHT ) ) moveX( keyboardMoveSpeed );
			if( keyIsDown( Keyboard.A ) || keyIsDown( Keyboard.LEFT ) ) moveX( -keyboardMoveSpeed );
			if( keyIsDown( Keyboard.Z ) ) moveY( keyboardMoveSpeed );
			if( keyIsDown( Keyboard.X ) ) moveY( -keyboardMoveSpeed );
			// ease position
			var dx:Number = _cameraDummy.x - _camera.x;
			var dy:Number = _cameraDummy.y - _camera.y;
			var dz:Number = _cameraDummy.z - _camera.z;
			_camera.x += dx * linearEase;
			_camera.y += dy * linearEase;
			_camera.z += dz * linearEase;
			// ease orientation
			dx = _cameraDummy.rotationX - _camera.rotationX;
			dy = _cameraDummy.rotationY - _camera.rotationY;
			dz = _cameraDummy.rotationZ - _camera.rotationZ;
			_camera.rotationX += dx * angularEase;
			_camera.rotationY += dy * angularEase;
			_camera.rotationZ += dz * angularEase;
		}

		public function rotateY( value:Number ):void {
			_cameraDummy.rotationY += value;
		}

		public function rotateX( value:Number ):void {
			_cameraDummy.rotationX += value;
		}

		public function moveX( value:Number ):void {
			_cameraDummy.moveRight( value );
		}

		public function moveY( value:Number ):void {
			_cameraDummy.moveUp( value );
		}

		public function moveZ( value:Number ):void {
			_cameraDummy.moveForward( value );
		}
	}
}
