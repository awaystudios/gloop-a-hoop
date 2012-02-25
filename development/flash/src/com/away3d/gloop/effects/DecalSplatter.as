package com.away3d.gloop.effects
{

	import away3d.containers.Scene3D;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;

	import flash.geom.Vector3D;

	public class DecalSplatter
	{
		public var numRays:uint = 1;
		public var apertureX:Number = 0;
		public var apertureY:Number = 0;
		public var apertureZ:Number = 0;
		public var sourcePosition:Vector3D;
		public var splatDirection:Vector3D;
		public var decals:Vector.<Entity>;
		public var zOffset:Number = 1;
		public var targets:Vector.<Mesh>;
		public var maxDistance:Number = 50;
		public var minScale:Number = 1;
		public var maxScale:Number = 1;
		public var shrinkFactor:Number = 0.99;

		private var _maxDecals:uint;
		private var _instantiatedDecals:Vector.<Entity>;
		private var _currentDecalIndex:uint;
		private var _meshCollider:MeshCollider;

		public function shrinkDecals():void {
			for( var i:uint, len:uint = _instantiatedDecals.length; i < len; ++i ) {
				var decal:Entity = _instantiatedDecals[ i ];
				decal.scale( shrinkFactor );
			}
		}

		public function DecalSplatter( maxDecals:uint = 10 ) {
			_maxDecals = maxDecals;
			_instantiatedDecals = new Vector.<Entity>();
			_meshCollider = new MeshCollider();
			sourcePosition = new Vector3D();
			splatDirection = new Vector3D( 0, 1, 0 );
		}

		public function evaluate():void {

			_meshCollider.updateTarget( targets );

			var rayPosition:Vector3D;
			var rayDirection:Vector3D;
			for( var i:uint; i < numRays; ++i ) {
				// update ray position
				rayPosition = sourcePosition.clone();
				rayDirection = splatDirection.clone();
				if( numRays > 1 ) {
					rayDirection.x += rand( -apertureX, apertureX );
					rayDirection.y += rand( -apertureY, apertureY );
					rayDirection.z += rand( -apertureZ, apertureZ );
				}
				_meshCollider.updateRay( rayPosition, rayDirection );
				// test
				if( _meshCollider.evaluate() ) {

					// evaluate decal position
					var position:Vector3D = _meshCollider.collidingMesh.sceneTransform.transformVector( _meshCollider.collisionPoint );
					var distance:Number = position.subtract( sourcePosition ).length;
					if( distance > maxDistance ) continue;
					placeDecalAt( position, rand( minScale, maxScale ) );
				}
			}
		}

		private function placeDecalAt( position:Vector3D, scale:Number = 1 ):void {
			var scene:Scene3D = _meshCollider.collidingMesh.scene;
			var decal:Entity = getNextDecal();
			decal.scale( scale );
			decal.position = position;
			scene.addChild( decal );
		}

		private function getNextDecal():Entity {
			var decal:Entity;
			if( _instantiatedDecals.length - 1 < _currentDecalIndex ) {
				var randDecalIndex:uint = Math.floor( Math.random() * decals.length );
				decal = decals[ randDecalIndex ].clone() as Entity;
			}
			else {
				decal = _instantiatedDecals[ _currentDecalIndex ];
				decal.scaleX = decal.scaleY = decal.scaleZ = 1;
			}
			_instantiatedDecals.push( decal );
			_currentDecalIndex++;
			if( _currentDecalIndex > _maxDecals ) _currentDecalIndex = 0;
			return decal;
		}

		private function rand( min:Number, max:Number ):Number {
			return (max - min) * Math.random() + min;
		}
	}
}
