package
{

	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.primitives.PlaneGeometry;

	import flash.geom.Vector3D;

	public class Room extends ObjectContainer3D
	{
		private var _floor:Mesh;
		private var _ceiling:Mesh;
		private var _rightWall:Mesh;
		private var _leftWall:Mesh;
		private var _backWall:Mesh;
		private var _frontWall:Mesh;
		private var _center:Vector3D;

		public function Room( dimensions:Vector3D, material:MaterialBase ) {
			super();

			_center = new Vector3D();

			var position:Vector3D;
			var wallDimensions:Vector3D;

			// floor
			position = new Vector3D( 0, -dimensions.y / 2, 0 );
			wallDimensions = new Vector3D( dimensions.x, dimensions.z );
			_floor = createWall( position, wallDimensions, material );

			// ceiling
			position = new Vector3D( 0, dimensions.y / 2, 0 );
			wallDimensions = new Vector3D( dimensions.x, dimensions.z );
			_ceiling = createWall( position, wallDimensions, material );

			// right wall
			position = new Vector3D( dimensions.x / 2, 0, 0 );
			wallDimensions = new Vector3D( dimensions.x, dimensions.y );
			_rightWall = createWall( position, wallDimensions, material );

			// left wall
			position = new Vector3D( -dimensions.x / 2, 0, 0 );
			wallDimensions = new Vector3D( dimensions.x, dimensions.y );
			_leftWall = createWall( position, wallDimensions, material );

			// front wall
			position = new Vector3D( 0, 0, dimensions.z / 2 );
			wallDimensions = new Vector3D( dimensions.x, dimensions.y );
			_frontWall = createWall( position, wallDimensions, material );

			// back wall
			position = new Vector3D( 0, 0, -dimensions.z / 2 );
			wallDimensions = new Vector3D( dimensions.x, dimensions.y );
			_backWall = createWall( position, wallDimensions, material );
		}

		private function createWall( position:Vector3D, dimensions:Vector3D, material:MaterialBase ):Mesh {
			var geometry:PlaneGeometry = new PlaneGeometry( dimensions.x, dimensions.y );
			var wall:Mesh = new Mesh( geometry, material );
			wall.position = position;
			wall.lookAt( _center );
			wall.rotationX += 90;
			addChild( wall );
			return wall;
		}

		public function get meshes():Vector.<Mesh> {
			return Vector.<Mesh>( [ _floor, _ceiling, _rightWall, _leftWall, _frontWall, _backWall ] );
		}
	}
}
