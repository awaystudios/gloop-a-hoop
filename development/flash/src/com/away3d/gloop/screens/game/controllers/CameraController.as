package com.away3d.gloop.screens.game.controllers
{
	import away3d.cameras.Camera3D;
	
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.input.InputManager;
	
	import flash.geom.Vector3D;

	public class CameraController
	{
		private var _inputManager : InputManager;
		private var _camera : Camera3D;
		private var _gloop : Gloop;
		
		private var _boundsMinX : Number;
		private var _boundsMaxX : Number;
		private var _boundsMinY : Number;
		private var _boundsMaxY : Number;
		private var _boundsMinZ : Number;
		private var _boundsMaxZ : Number;
		
		private var _offX : Number;
		private var _offY : Number;
		
		private var _finishMode : Boolean;
		private var _finishTargetRotation : Number;
		
		private var _gloopIsFlying : Boolean;
		private var _interactedSinceGloopWasFired:Boolean;
		
		public function CameraController(inputManager : InputManager, camera : Camera3D, gloop : Gloop)
		{
			_inputManager = inputManager;
			_camera = camera;
			_gloop = gloop;
		}
		
		
		public function resetOrientation() : void
		{
			_camera.rotationX *= 0.9;
			_camera.rotationY *= 0.9;
			_camera.rotationZ *= 0.9;
		}
		
		
		public function setGloopFired(offX : Number, offY : Number) : void
		{
			_gloopIsFlying = true;
			_offX = offX;
			_offY = offY;
			_interactedSinceGloopWasFired = false;
		}
		
		
		
		public function setGloopFinishing(targetRotationRadians : Number) : void
		{
			_finishMode = true;
			_finishTargetRotation = targetRotationRadians;
		}
		
		
		public function setGloopIdle() : void
		{
			_finishMode = false;
			_gloopIsFlying = false;
		}
		
		
		public function setBounds(minX : Number, maxX : Number, minY : Number, maxY : Number, minZ : Number, maxZ : Number ) : void
		{
			_boundsMinX = minX;
			_boundsMaxX = maxX;
			_boundsMinY = minY;
			_boundsMaxY = maxY;
			_boundsMinZ = minZ;
			_boundsMaxZ = maxZ;
		}
		
		
		public function update() : void
		{
			var ease : Number;
			var targetPosition:Vector3D = new Vector3D( 0, 0, 1 );

			if( _inputManager.interacting ) _interactedSinceGloopWasFired = true;
			
			// Default easing
			ease = 0.4;

			// evaluate target camera position
			// TODO: verify if this works correctly on mobile ( follows gloop on a shot but stops following as soon as the view is panned )
			if( !_interactedSinceGloopWasFired && _gloopIsFlying ) {
				_offX *= 0.9;
				_offY *= 0.9;
				targetPosition.x = _gloop.physics.x + _offX;
				targetPosition.y = -_gloop.physics.y + _offY;
				_inputManager.panX = targetPosition.x;
				_inputManager.panY = targetPosition.y;
				_camera.lookAt( new Vector3D( targetPosition.x, targetPosition.y, 0 ) );
				
				if (_finishMode) {
					targetPosition.x += -150 * Math.sin(_finishTargetRotation);
					targetPosition.y += 150 * Math.cos(_finishTargetRotation);
					targetPosition.z = 50;
					ease = 0.2;
				}
				else {
					targetPosition.z = _inputManager.zoom;
				}
			}
			else {
				_inputManager.update();
				targetPosition.x = _inputManager.panX;
				targetPosition.y = _inputManager.panY;
				targetPosition.z = _inputManager.zoom;
				resetOrientation();
			}

			// contain target position
			if( targetPosition.x > _boundsMaxX ) {
				targetPosition.x *= 0.95;
				_inputManager.panX = targetPosition.x;
				_inputManager.resetVelocities();
			} else if( targetPosition.x < _boundsMinX ) {
				targetPosition.x *= 0.95;
				_inputManager.panX = targetPosition.x;
				_inputManager.resetVelocities();
			}
			if( targetPosition.y > _boundsMaxY ) {
				targetPosition.y *= 0.95;
				_inputManager.panY = targetPosition.y;
				_inputManager.resetVelocities();
			} else if( targetPosition.y < _boundsMinY ) {
				targetPosition.y *= 0.95;
				_inputManager.panY = targetPosition.y;
				_inputManager.resetVelocities();
			}
			if( targetPosition.z > _boundsMaxZ ) {
				targetPosition.z = _boundsMaxZ;
				_inputManager.zoom = _boundsMaxZ;
			} else if( targetPosition.z < _boundsMinZ ) {
				targetPosition.z = _boundsMinZ;
				_inputManager.zoom = _boundsMinZ;
			}

			// ease camera towards target position
			_camera.x += (targetPosition.x - _camera.x) * ease;
			_camera.y += (targetPosition.y - _camera.y) * ease;
			_camera.z += ( ( targetPosition.z * 200 - 1000 ) - _camera.z) * ease;
		}
	}
}