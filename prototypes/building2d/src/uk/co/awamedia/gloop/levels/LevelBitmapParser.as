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
	import flash.geom.Rectangle;

	public class LevelBitmapParser
	{
		private var _grid_size : Number;
		private var _spawn_point : Point;
		
		private var _light : DirectionalLight;
		
		private static const WALL : uint = 0xff000000;
		private static const SPAWN : uint = 0xff00ff00;
		
		
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
			var posx : uint;
			var posy : uint;
			var plane : Mesh;
			var pixels : Vector.<uint>;
			
			var ctr : ObjectContainer3D = new ObjectContainer3D();
			var mat : ColorMaterial = new ColorMaterial(0xffcc00);
			
			_light = new DirectionalLight(1, -1, 2);
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
				
				px = pixels[i];
				if (px==WALL) {
					var mesh : Mesh;
					var r : Rectangle;
					var cube : CubeGeometry;
					
					r = findRect(pixels, bmp.width, bmp.height, posx, posy);
					
					cube = new CubeGeometry(r.width * _grid_size, r.height * _grid_size, 4 * _grid_size);
					
					mesh = new Mesh(cube, mat);
					mesh.x = posx * _grid_size + r.width * _grid_size/2;
					mesh.y = -posy * _grid_size - r.height * _grid_size/2;
					ctr.addChild(mesh);
				}
				else if (px == SPAWN) {
					_spawn_point = new Point(posx * _grid_size, -posy * _grid_size);
				}
				
				posx = (posx+1) % bmp.width;
				if (posx==0)
					posy++}
			
			plane = new Mesh(new PlaneGeometry(bmp.width * _grid_size, bmp.height * _grid_size, 1, 1, false), new ColorMaterial(0xcccccc));
			plane.x = bmp.width/2 * _grid_size;
			plane.y = -bmp.height/2 * _grid_size;
			plane.z = _grid_size*2;
			plane.material.lightPicker = new StaticLightPicker([_light]);
			ctr.addChild(plane);
			
			return ctr;
		}
		
		
		private function findRect(pixels : Vector.<uint>, bmpw : uint, bmph : uint, posx : uint, posy : uint) : Rectangle
		{
			var start : uint;
			var len : uint;
			var rect : Rectangle;
			var maxw : uint;
			var maxh : uint;
			var w : uint;
			var h : uint;
			var inds : Vector.<uint>;
			
			rect = new Rectangle(posx, posy);
			
			start = posy*bmpw + posx;
			len = pixels.length;
			
			w = 1;
			h = 1;
			maxw = bmpw - posx;
			maxh = bmph - posy;
			
			// Go right as far as possible
			while (w < maxw && pixels[ start + w ] == WALL) {
				pixels[start+w] = 0; // Mark as processed
				w++;
			}
			
			inds = new Vector.<uint>(w, true);
			
			// Go down as far as possible, checking 
			// the entire width for each step.
			downward: while (h < maxh) {
				var i : uint;
				
				for (i=0; i<w; i++) {
					var idx : uint;
					
					idx = start + h*bmpw + i;
					if (pixels[idx] != WALL)
						break downward;
					
					inds[i] = idx;
				}
				
				// Made it? Mark entire row as processed
				for (i=0; i<w; i++) {
					pixels[ inds[i] ] = 0;
				}
				
				h++;
			}
			
			rect.width = w;
			rect.height = h;
			
			trace(rect);
			
			return rect;
		}
	}
}