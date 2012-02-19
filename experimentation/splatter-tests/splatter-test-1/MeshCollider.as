package
{

	import away3d.core.base.SubMesh;
	import away3d.core.raycast.colliders.ColliderBase;
	import away3d.core.raycast.colliders.TriangleCollider;
	import away3d.entities.Mesh;

	import flash.geom.Vector3D;

	public class MeshCollider extends ColliderBase
	{
		private var _triangleCollider:TriangleCollider;
		private var _nearestCollisionVO:MeshCollisionVO;

		public function MeshCollider() {
			super();
			_triangleCollider = new TriangleCollider();
		}

		override public function evaluate():Boolean {

			var meshes:Vector.<Mesh> = _target as Vector.<Mesh>;

			var t:Number;
			var mesh:Mesh;
			var rp:Vector3D, rd:Vector3D;
			var collisionVO:MeshCollisionVO;
			var cameraIsInEntityBounds:Boolean;
			var collisionVOs:Vector.<MeshCollisionVO> = new Vector.<MeshCollisionVO>();

			// sweep meshes and collect entities whose bounds are hit by ray
			for( var i:uint, len:uint = meshes.length; i < len; ++i ) {
				mesh = meshes[ i ];
				if( mesh.visible ) {
					// convert ray to object space
					rp = mesh.inverseSceneTransform.transformVector( _rayPosition );
					rd = mesh.inverseSceneTransform.deltaTransformVector( _rayDirection );
					// check for ray-bounds collision
					t = mesh.bounds.intersectsRay( rp, rd );
					cameraIsInEntityBounds = false;
					if( t == -1 ) { // if there is no collision, check if the ray starts inside the bounding volume
						cameraIsInEntityBounds = mesh.bounds.containsPoint( rp );
						if( cameraIsInEntityBounds ) t = 0;
					}
					if( t >= 0 ) { // collision exists for this renderable's entity bounds
						// store collision VO
						collisionVO = new MeshCollisionVO();
						collisionVO.boundsCollisionT = t;
						collisionVO.boundsCollisionFarT = mesh.bounds.rayFarT;
						collisionVO.mesh = mesh;
						collisionVO.localRayPosition = rp;
						collisionVO.localRayDirection = rd;
						collisionVO.cameraIsInEntityBounds = cameraIsInEntityBounds;
						collisionVOs.push( collisionVO );
					}
				}
			}

			// no bound hits?
			var numBoundHits:uint = collisionVOs.length;
			if( numBoundHits == 0 ) return _collisionExists = false;

			// sort collision vos, closest to furthest
			collisionVOs = collisionVOs.sort( onSmallestT );

			var subMesh:SubMesh;

			// find nearest collision and perform triangle collision tests where necessary
			_nearestCollisionVO = new MeshCollisionVO();
			_nearestCollisionVO.finalCollisionT = Number.MAX_VALUE;
			_nearestCollisionVO.boundsCollisionT = Number.MAX_VALUE;
			_nearestCollisionVO.boundsCollisionFarT = Number.MAX_VALUE;
			for( i = 0; i < numBoundHits; ++i ) {
				collisionVO = collisionVOs[ i ];
				// this collision could only be closer if the bounds collision t is closer, otherwise, no need to test ( except if bounds intersect )
				if( collisionVO.cameraIsInEntityBounds
						|| collisionVO.boundsCollisionT < _nearestCollisionVO.finalCollisionT
						|| ( collisionVO.boundsCollisionT > _nearestCollisionVO.boundsCollisionT && collisionVO.boundsCollisionT < _nearestCollisionVO.boundsCollisionFarT ) ) { // bounds intersection test
					_triangleCollider.updateRay( collisionVO.localRayPosition, collisionVO.localRayDirection );
					subMesh = mesh.subMeshes[ 0 ];
					_triangleCollider.breakOnFirstTriangleHit = false;
					_triangleCollider.updateTarget( subMesh );
					if( _triangleCollider.evaluate() ) { // triangle collision exists?
						collisionVO.finalCollisionT = _triangleCollider.collisionT;
						collisionVO.collisionUV = _triangleCollider.collisionUV.clone();
						collisionVO.collisionNormal = _triangleCollider.collisionNormal.clone();
						if( collisionVO.finalCollisionT < _nearestCollisionVO.finalCollisionT ) _nearestCollisionVO = collisionVO;
					}
				}
			}

			// use nearest collision found
			_t = _nearestCollisionVO.finalCollisionT;
			_collidingRenderable = _nearestCollisionVO.mesh.subMeshes[ 0 ];
			return _collisionExists = _nearestCollisionVO.finalCollisionT != Number.MAX_VALUE;
		}

		private function onSmallestT( a:MeshCollisionVO, b:MeshCollisionVO ):Number {
			return a.boundsCollisionT < b.boundsCollisionT ? -1 : 1;
		}

		public function get collidingMesh():Mesh {
			if( !_collisionExists )
				return null;
			return _nearestCollisionVO.mesh;
		}

		public function get collisionNormal():Vector3D {
			if( !_collisionExists ) return null;
			return _nearestCollisionVO.collisionNormal;
		}

		override public function get collisionPoint():Vector3D {
			if( !_collisionExists )
				return null;

			var point:Vector3D = new Vector3D();
			point.x = _nearestCollisionVO.localRayPosition.x + _nearestCollisionVO.finalCollisionT * _nearestCollisionVO.localRayDirection.x;
			point.y = _nearestCollisionVO.localRayPosition.y + _nearestCollisionVO.finalCollisionT * _nearestCollisionVO.localRayDirection.y;
			point.z = _nearestCollisionVO.localRayPosition.z + _nearestCollisionVO.finalCollisionT * _nearestCollisionVO.localRayDirection.z;
			return point;
		}
	}
}

import away3d.entities.Mesh;

import flash.geom.Point;
import flash.geom.Vector3D;

class MeshCollisionVO
{
	public var boundsCollisionT:Number;
	public var boundsCollisionFarT:Number;
	public var finalCollisionT:Number;
	public var mesh:Mesh;
	public var collisionUV:Point;
	public var collisionNormal:Vector3D;
	public var localRayPosition:Vector3D;
	public var localRayDirection:Vector3D;
	public var cameraIsInEntityBounds:Boolean;

	public function MeshCollisionVO() {
	}
}
