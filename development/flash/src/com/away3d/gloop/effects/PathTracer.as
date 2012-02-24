package com.away3d.gloop.effects
{

	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.SphereGeometry;

	public class PathTracer extends Mesh
	{
		private var _pathEntry:Mesh;
		private var _paths:Vector.<Mesh>;
		private var _currentPath:Mesh;

		public var minScale:Number = 0.5;
		public var maxScale:Number = 1;

		// TODO: manage path entry pool
		// TODO: trace points at a constant distance, independent of physics speed

		public function PathTracer() {

			super();
			_paths = new Vector.<Mesh>();
			_pathEntry = new Mesh( new SphereGeometry( 5 ), new ColorMaterial( 0xFFFFFF ) );
		}

		public function tracePoint( x:Number, y:Number, z:Number ):void {
			if( !_currentPath ) return;
			var entry:Mesh = _pathEntry.clone() as Mesh;
			entry.x = x;
			entry.y = y;
			entry.z = z;
			entry.scale( rand( minScale, maxScale ) );
			_currentPath.addChild( entry );
		}

		public function createNewPath():void {
			_currentPath = new Mesh();
			addChild( _currentPath );
			_paths.push( _currentPath );
		}

		public function deletePath( index:uint ):void {
			var path:Mesh = _paths[ index ];
			removeChild( path );
			_paths.splice( _paths.indexOf( path ), 1 );
			path = null;
			if( _paths.length > 0 ) {
				_currentPath = _paths[ 0 ];
			}
		}

		public function get numPaths():uint {
			return _paths.length;
		}

		private function rand(min:Number, max:Number):Number
		{
		    return (max - min)*Math.random() + min;
		}
	}
}
