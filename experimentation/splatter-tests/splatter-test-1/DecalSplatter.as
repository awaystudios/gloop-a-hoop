package
{

	import away3d.containers.Scene3D;
	import away3d.entities.Mesh;

	import flash.geom.Vector3D;

	public class DecalSplatter
	{
		public var numRays:uint = 1;
		public var aperture:Number = 0;
		public var sourcePosition:Vector3D;
		public var splattDirection:Vector3D;
		public var decals:Vector.<Mesh>;
		public var zOffset:Number = 5;

		private var _meshCollider:MeshCollider;

		public function DecalSplatter() {
			_meshCollider = new MeshCollider();
		}

		// TODO: implement projective zOffset, clip decals on edges, use circular random position instead of square, improve performance
		public function evaluate( meshes:Vector.<Mesh> ):void {

			_meshCollider.updateTarget( meshes );

			var rayPosition:Vector3D;
			var rayDirection:Vector3D;
			for( var i:uint; i < numRays; ++i ) {
				// update ray position // TODO: apply randomization
				rayPosition = sourcePosition.clone();
				rayDirection = splattDirection.clone();
				if( numRays > 1 ) {
					rayDirection.x += rand( -aperture, aperture );
					rayDirection.y += rand( -aperture, aperture );
					rayDirection.z += rand( -aperture, aperture );
				}
				_meshCollider.updateRay( rayPosition, rayDirection );
				// test
				if( _meshCollider.evaluate() ) {

					// create a decal
					var scene:Scene3D = _meshCollider.collidingMesh.scene;
					var randDecalIndex:uint = Math.floor( Math.random() * decals.length );
					var decal:Mesh = decals[ randDecalIndex ].clone() as Mesh;

					// evaluate decal position
					var position:Vector3D = _meshCollider.collidingMesh.sceneTransform.transformVector( _meshCollider.collisionPoint );
					var normal:Vector3D = _meshCollider.collisionNormal;
					normal = _meshCollider.collidingMesh.sceneTransform.deltaTransformVector( _meshCollider.collisionNormal );
					normal.scaleBy( zOffset );
					position = position.add( normal );
					decal.position = position;

					// evaluate decal orientation
					normal.scaleBy( 50 );
					var offsetPosition:Vector3D = position.add( normal );
					decal.lookAt( offsetPosition, new Vector3D( rand( -1, 1 ), rand( -1, 1 ), rand( -1, 1 ) ) );

					scene.addChild( decal );

				}
			}
		}

		private function rand( min:Number, max:Number ):Number {
			return (max - min) * Math.random() + min;
		}
	}
}
