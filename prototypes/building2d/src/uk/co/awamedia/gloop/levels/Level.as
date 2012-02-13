package uk.co.awamedia.gloop.levels
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import uk.co.awamedia.gloop.gameobjects.Hoop;

	public class Level
	{
		private var _w : uint;
		private var _h : uint;
		
		internal var _spawn_point : Point;
		internal var _walls : Vector.<Rectangle>;
		internal var _hoops : Vector.<Hoop>;
		
		public function Level(w : uint, h : uint)
		{
			_w = w;
			_h = h;
			_walls = new Vector.<Rectangle>();
			_hoops = new Vector.<Hoop>();
		}
		
		
		public function get spawnPoint() : Point
		{
			return _spawn_point;
		}
		
		public function get hoops():Vector.<Hoop> {
			return _hoops;
		}
		
		
		public function update(timeDelta : Number = 1) : void
		{
			var i : uint;
			
			for (i=0; i<_hoops.length; i++) {
				_hoops[i].update(timeDelta);
			}
		}
		
		
		public function construct(lights : Array, gridSize : Number = 20) : ObjectContainer3D
		{
			var r : Rectangle;
			var plane : Mesh;
			var hoop : Hoop;
			var mesh : Mesh;
			var ctr : ObjectContainer3D = new ObjectContainer3D();
			var back_mat : ColorMaterial;
			var wall_mat : ColorMaterial;
			var hoop_mat : ColorMaterial;
			
			wall_mat = new ColorMaterial(0x888888);
			wall_mat.lightPicker = new StaticLightPicker(lights);
			wall_mat.gloss = 0.2;
			wall_mat.specular = 0.6;
			
			hoop_mat = new ColorMaterial(0xff0000);
			hoop_mat.lightPicker = new StaticLightPicker(lights);
					
			for each (r in _walls) {
				var cube : CubeGeometry;
				
				cube = new CubeGeometry(r.width * gridSize, r.height * gridSize, 6 * gridSize);
				mesh = new Mesh(cube, wall_mat);
				mesh.x = r.x * gridSize + r.width * gridSize/2;
				mesh.y = -r.y * gridSize - r.height * gridSize/2;
				ctr.addChild(mesh);
			}
			
			for each (hoop in _hoops) {
				var cylinder : CylinderGeometry;
				
				cylinder = new CylinderGeometry(gridSize * 3, gridSize * 3, 0.1*gridSize);
				mesh = new Mesh(cylinder, hoop_mat);
				mesh.x = hoop.position.x * gridSize;
				mesh.y = -hoop.position.y * gridSize;
				
				hoop.mesh = mesh;
				ctr.addChild(mesh);
			}
			
			back_mat = new ColorMaterial(0xcccccc);
			back_mat.gloss = 0.2;
			back_mat.specular = 0.6;
			
			plane = new Mesh(new PlaneGeometry(_w * gridSize, _h * gridSize, 1, 1, false), back_mat);
			plane.x = _w/2 * gridSize;
			plane.y = -_h/2 * gridSize;
			plane.z = gridSize*3;
			plane.material.lightPicker = new StaticLightPicker(lights);
			ctr.addChild(plane);
			
			return ctr;
		}
	}
}