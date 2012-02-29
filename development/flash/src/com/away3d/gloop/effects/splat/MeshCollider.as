package com.away3d.gloop.effects.splat
{
	
	import away3d.core.base.SubMesh;
	import away3d.core.raycast.colliders.ColliderBase;
	import away3d.entities.Mesh;
	
	import flash.geom.Vector3D;
	
	public class MeshCollider extends ColliderBase
	{
		private var _triangleCollider:AS3TriangleCollider;
		private var _collisionVO:MeshCollisionVO;
		
		public function MeshCollider() {
			super();
			_triangleCollider = new AS3TriangleCollider();
		}
		
		override public function evaluate():Boolean {
			
			var meshes:Vector.<Mesh> = _target as Vector.<Mesh>;
			
			var t:Number;
			var rp:Vector3D, rd:Vector3D;
			var collisionVO:MeshCollisionVO;
			var sourceIsInEntityBounds:Boolean;
			var collisionVOs:Vector.<MeshCollisionVO> = new Vector.<MeshCollisionVO>();
			
			// sweep meshes and collect entities whose bounds are hit by ray
			for( var i:uint, len:uint = meshes.length; i < len; ++i ) {
				var mesh:Mesh = meshes[ i ];
				if( mesh.visible ) {
					// convert ray to object space
					rp = mesh.inverseSceneTransform.transformVector( _rayPosition );
					rd = mesh.inverseSceneTransform.deltaTransformVector( _rayDirection );
					// check for ray-bounds collision
					t = mesh.bounds.intersectsRay( rp, rd );
					sourceIsInEntityBounds = false;
					if( t == -1 ) { // if there is no collision, check if the ray starts inside the bounding volume
						sourceIsInEntityBounds = mesh.bounds.containsPoint( rp );
						if( sourceIsInEntityBounds ) t = 999;
					}
					if( t >= 0 ) { // collision exists for this renderable's entity bounds
						// store collision VO
						collisionVO = new MeshCollisionVO();
						collisionVO.boundsCollisionT = t;
						collisionVO.mesh = mesh;
						collisionVO.localRayPosition = rp;
						collisionVO.localRayDirection = rd;
						collisionVO.cameraIsInEntityBounds = sourceIsInEntityBounds;
						collisionVOs.push( collisionVO );
					}
				}
			}
			
			// no bound hits?
			var numBoundHits:uint = collisionVOs.length;
			if( numBoundHits == 0 ) return _collisionExists = false;
			
			// sort collision vos, closest to furthest
			collisionVOs = collisionVOs.sort( onSmallestT );
			
			// find nearest collision and perform triangle collision tests where necessary
			for( i = 0; i < numBoundHits; ++i ) {
				_collisionVO = collisionVOs[ i ];
				// this collision could only be closer if the bounds collision t is closer, otherwise, no need to test ( except if bounds intersect )
				_triangleCollider.updateRay( _collisionVO.localRayPosition, _collisionVO.localRayDirection );
				var subMesh:SubMesh = _collisionVO.mesh.subMeshes[ 0 ];
				_triangleCollider.updateTarget( subMesh );
				if( _triangleCollider.evaluate() ) { // triangle collision exists?
					_collisionVO.finalCollisionT = _triangleCollider.collisionT;
					_t = _collisionVO.finalCollisionT;
					_collidingRenderable = _collisionVO.mesh.subMeshes[ 0 ];
					return _collisionExists = true;
				}
			}
			
			return _collisionExists = false;
		}
		
		private function onSmallestT( a:MeshCollisionVO, b:MeshCollisionVO ):Number {
			return a.boundsCollisionT < b.boundsCollisionT ? -1 : 1;
		}
		
		public function get collidingMesh():Mesh {
			if( !_collisionExists )
				return null;
			return _collisionVO.mesh;
		}
		
		override public function get collisionPoint():Vector3D {
			if( !_collisionExists )
				return null;
			var point:Vector3D = new Vector3D();
			point.x = _collisionVO.localRayPosition.x + _collisionVO.finalCollisionT * _collisionVO.localRayDirection.x;
			point.y = _collisionVO.localRayPosition.y + _collisionVO.finalCollisionT * _collisionVO.localRayDirection.y;
			point.z = _collisionVO.localRayPosition.z + _collisionVO.finalCollisionT * _collisionVO.localRayDirection.z;
			return point;
		}
	}
}

import away3d.entities.Mesh;

import flash.geom.Vector3D;

class MeshCollisionVO
{
	public var boundsCollisionT:Number;
	public var finalCollisionT:Number;
	public var mesh:Mesh;
	public var collisionNormal:Vector3D;
	public var localRayPosition:Vector3D;
	public var localRayDirection:Vector3D;
	public var cameraIsInEntityBounds:Boolean;
	
	public function MeshCollisionVO() {
	}
}