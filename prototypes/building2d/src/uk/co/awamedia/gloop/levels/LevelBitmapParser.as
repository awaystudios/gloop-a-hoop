package uk.co.awamedia.gloop.levels
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class LevelBitmapParser
	{
		private var _grid_size : Number;
		private var _spawn_point : Point;
		
		private var _light : DirectionalLight;
		
		
		public function LevelBitmapParser(gridSize : Number = 10)
		{
			_grid_size = gridSize;
		}
		
		
		public function get light() : DirectionalLight
		{
			return _light;
		}
		
		
		public function get spawnPoint() : Point
		{
			return _spawn_point;
		}
		
		
		public function parseBitmap(bmp : BitmapData) : ObjectContainer3D
		{
			var i : uint;
			var len : uint;
			var posx : Number;
			var posy : Number;
			var plane : Mesh;
			var pixels : Vector.<uint>;
			
			var ctr : ObjectContainer3D = new ObjectContainer3D();
			var mat : ColorMaterial = new ColorMaterial(0xffcc00);
			var cube : CubeGeometry = new CubeGeometry(_grid_size, _grid_size, _grid_size*4);
			
			_light = new DirectionalLight(1, -1, 1);
			_light.ambient = 0;
			ctr.addChild(_light);
			
			mat.lightPicker = new StaticLightPicker([_light]);
			
			// TODO: Optimize level output
			
			pixels = bmp.getVector(bmp.rect);
			len = pixels.length;
			
			posx = 0;
			posy = 0;
			
			for (i=0; i<len; i++) {
				var px : uint;
				
				px = pixels[i] & 0xffffff;
				if (px==0) {
					var mesh : Mesh;
					
					mesh = new Mesh(cube, mat);
					mesh.x = posx * _grid_size;
					mesh.y = posy * _grid_size;
					ctr.addChild(mesh);
				}
				else if (px == 0x00ff00) {
					_spawn_point = new Point(posx * _grid_size, posy * _grid_size);
				}
				
				posx = (posx+1) % bmp.width;
				if (posx==0)
					posy--;
			}
			
			plane = new Mesh(new PlaneGeometry(bmp.width * _grid_size, bmp.height * _grid_size), new ColorMaterial(0xcccccc));
			plane.x = bmp.width/2 * _grid_size;
			plane.y = -bmp.height/2 * _grid_size;
			plane.z = _grid_size*2;
			plane.material.lightPicker = new StaticLightPicker([_light]);
			ctr.addChild(plane);
			
			return ctr;
		}
	}
}