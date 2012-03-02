package com.away3d.gloop.screens.game.controllers
{

	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.input.InputManager;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class CameraController
	{
		private var _inputManager : InputManager;
		private var _camera : Camera3D;
		private var _gloop : Gloop;
		
		private var _lookAtTarget : Vector3D;
		
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

		private var _containVector:Point = new Point();

		private var _cameraHorizontalFovFactor:Number;
		private var _cameraVerticalFovFactor:Number;
		private var _levelVisibleHalfRange:Number;
		
		public function CameraController(inputManager : InputManager, camera : Camera3D, gloop : Gloop)
		{
			_inputManager = inputManager;
			_camera = camera;
			_gloop = gloop;
			
			_lookAtTarget = new Vector3D();
		}
		
		
		public function resetOrientation() : void
		{
			_camera.rotationX *= 0.9;
			_camera.rotationY *= 0.9;
			_camera.rotationZ *= 0.9;
			
			_lookAtTarget.x = _camera.x;
			_lookAtTarget.y = _camera.y;
		}
		
		
		public function setGloopFired(offX : Number, offY : Number) : void
		{
			_gloopIsFlying = true;
			_offX = offX;
			_offY = offY;
			_interactedSinceGloopWasFired = false;
		}
		
		
		public function setGloopMissed() : void
		{
			_finishMode = false;
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

		public function setBounds(minX : Number, maxX : Number, minY : Number, maxY : Number, maxZoom : Number ) : void
		{
			_boundsMinX = minX;
			_boundsMaxX = maxX;
			_boundsMinY = minY;
			_boundsMaxY = maxY;
			_boundsMaxZ = maxZoom;

			// evaluate camera z factor ( relates pan limits to camera z )
			var halfRangeX:Number = ( _boundsMaxX - _boundsMinX ) / 2;
			var halfRangeY:Number = ( _boundsMaxY - _boundsMinY ) / 2;
			_levelVisibleHalfRange = Math.min( halfRangeX, halfRangeY );
			var hViewAngle:Number = PerspectiveLens( _camera.lens ).fieldOfView / 2;
			_cameraHorizontalFovFactor = Math.tan( hViewAngle * Math.PI / 180 );
			var vViewAngle:Number = hViewAngle / _camera.lens.aspectRatio;
			_cameraVerticalFovFactor = Math.tan( vViewAngle * Math.PI / 180 );

			// evaluate and set min zoom
			var maxHorizontalZ:Number = halfRangeX / _cameraHorizontalFovFactor;
			var maxVerticalZ:Number = halfRangeY / _cameraVerticalFovFactor;
			var maxTotalZ:Number = Math.min( maxHorizontalZ, maxVerticalZ );
			_camera.z = -maxTotalZ;
			_inputManager.zoom = _boundsMinZ = ( -maxTotalZ + 1000 ) / 200;

			// uncomment to trace pan containment values from level.
//			var tracePlane:Mesh = new Mesh( new PlaneGeometry( 2 * halfRangeX, 2 * halfRangeY ), new ColorMaterial( 0x00FF00, 0.5 ) );
//			tracePlane.rotationX = -90;
//			_camera.scene.addChild( tracePlane );
		}

		public function update() : void
		{
			var ease : Number;
			var lookAtGloop : Boolean;
			var targetPosition:Vector3D = new Vector3D( 0, 0, 1 );

			if( _inputManager.interacting ) _interactedSinceGloopWasFired = true;
			
			// Default easing
			ease = 0.4;

			// evaluate target camera position
			// TODO: confirmed, _interactedSinceGloopWasFired is not working on mobile
			if( !_interactedSinceGloopWasFired && _gloopIsFlying ) {
				_offX *= 0.9;
				_offY *= 0.9;
				targetPosition.x = _gloop.physics.x + _offX;
				targetPosition.y = -_gloop.physics.y + _offY;
				_inputManager.panX = targetPosition.x;
				_inputManager.panY = targetPosition.y;
				_camera.lookAt( new Vector3D( targetPosition.x, targetPosition.y, 0 ) );
				
				if (_finishMode) {
					lookAtGloop = true;
					targetPosition.x += -150 * Math.sin(_finishTargetRotation);
					targetPosition.y += 150 * Math.cos(_finishTargetRotation);
					targetPosition.z = _boundsMaxZ;
					ease = 0.2;
				}
				else {
					lookAtGloop = false;
					targetPosition.z = _inputManager.zoom;
				}
			}
			else {
				lookAtGloop = false;

				if( !_inputManager.interacting ) {
					if( _containVector.x != 0 ) {
						_inputManager.panX += 0.25 * _containVector.x;
						_inputManager.applyImpulse( 0.05 * _containVector.x, 0 );
					}
					if( _containVector.y != 0 ) {
						_inputManager.panY += 0.25 * _containVector.y;
						_inputManager.applyImpulse( 0, 0.05 * _containVector.y );
					}
				}

				_inputManager.update();
				targetPosition.x = _inputManager.panX;
				targetPosition.y = _inputManager.panY;
				targetPosition.z = _inputManager.zoom;
				resetOrientation();
			}

			// evaluate containment
			var horizontalVisibleHalfRange:Number = -_camera.z * _cameraHorizontalFovFactor;
			var verticalVisibleHalfRange:Number = -_camera.z * _cameraVerticalFovFactor;
			var panRightDistance:Number = _boundsMaxX - ( _inputManager.panX + horizontalVisibleHalfRange );
			var panLeftDistance:Number = ( _inputManager.panX - horizontalVisibleHalfRange ) - _boundsMinX;
			var panUpDistance:Number = _boundsMaxY - ( _inputManager.panY + verticalVisibleHalfRange );
			var panDownDistance:Number = ( _inputManager.panY - verticalVisibleHalfRange ) - _boundsMinY;

			// hard XY containment
			if( panRightDistance < 0 ) {
				_inputManager.panX = targetPosition.x = _boundsMaxX - horizontalVisibleHalfRange;
			} else if( panLeftDistance < 0 ) {
				_inputManager.panX = targetPosition.x = _boundsMinX + horizontalVisibleHalfRange;
			}
			if( panUpDistance < 0 ) {
				_inputManager.panY = targetPosition.y = _boundsMaxY - verticalVisibleHalfRange;
			} else if( panDownDistance < 0 ) {
				_inputManager.panY = targetPosition.y = _boundsMinY + verticalVisibleHalfRange;
			}

			// soft XY containment
			_containVector.x = 0; // TODO: if soft containment is not picked, remove all related logic
			_containVector.y = 0;
			/*if( panRightDistance < 0 ) {
				_containVector.x = panRightDistance;
			} else if( panLeftDistance < 0 ) {
				_containVector.x = -panLeftDistance;
			}
			if( panUpDistance < 0 ) {
				_containVector.y = panUpDistance;
			} else if( panDownDistance < 0 ) {
				_containVector.y = -panDownDistance;
			}*/
			

			// hard containment for zoom
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
			
			if (lookAtGloop) {
				_lookAtTarget.x += (_gloop.meshComponent.mesh.x - _lookAtTarget.x) * ease;
				_lookAtTarget.y += (_gloop.meshComponent.mesh.y - _lookAtTarget.y) * ease;
			}
			else {
				_lookAtTarget.x += (_camera.x - _lookAtTarget.x) * ease;
				_lookAtTarget.y += (_camera.y - _lookAtTarget.y) * ease;
			}
			
			_camera.lookAt(_lookAtTarget);
		}
	}
}