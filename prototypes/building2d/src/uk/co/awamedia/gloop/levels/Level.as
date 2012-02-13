package uk.co.awamedia.gloop.levels
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Level
	{
		private var _w : uint;
		private var _h : uint;
		
		internal var _spawn_point : Point;
		internal var _walls : Vector.<Rectangle>;
		
		public function Level(w : uint, h : uint)
		{
			_w = w;
			_h = h;
			_walls = new Vector.<Rectangle>();
		}
		
		
		public function get spawnPoint() : Point
		{
			return _spawn_point;
		}
		
		
		public function construct(lights : Array, gridSize : Number = 20) : ObjectContainer3D
		{
			var r : Rectangle;
			var plane : Mesh;
			var ctr : ObjectContainer3D = new ObjectContainer3D();
			var mat : ColorMaterial = new ColorMaterial(0xffcc00);
			
			mat.lightPicker = new StaticLightPicker(lights);
					
			for each (r in _walls) {
				var mesh : Mesh;
				var cube : CubeGeometry;
				
				cube = new CubeGeometry(r.width * gridSize, r.height * gridSize, 4 * gridSize);
				mesh = new Mesh(cube, mat);
				mesh.x = r.x * gridSize + r.width * gridSize/2;
				mesh.y = -r.y * gridSize - r.height * gridSize/2;
				ctr.addChild(mesh);
			}
			
			plane = new Mesh(new PlaneGeometry(_w * gridSize, _h * gridSize, 1, 1, false), new ColorMaterial(0xcccccc));
			plane.x = _w/2 * gridSize;
			plane.y = -_h/2 * gridSize;
			plane.z = gridSize*2;
			plane.material.lightPicker = new StaticLightPicker(lights);
			ctr.addChild(plane);
			
			return ctr;
		}
	}
}