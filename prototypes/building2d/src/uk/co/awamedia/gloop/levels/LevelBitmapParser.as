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
	import uk.co.awamedia.gloop.Settings;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import uk.co.awamedia.gloop.gameobjects.Hoop;

	public class LevelBitmapParser
	{
		private static const WALL : uint = 0xff000000;
		private static const SPAWN : uint = 0xff00ff00;
		private static const HOOP : uint = 0xffff0000;
		
		
		public function LevelBitmapParser()
		{
		}
		
		
		public function parseBitmap(bmp : BitmapData) : Level
		{
			var i : uint;
			var len : uint;
			var posx : uint;
			var posy : uint;
			var pixels : Vector.<uint>;
			var level : Level;
			
			level = new Level(bmp.width, bmp.height);
			level._bmp = bmp;
			
			pixels = bmp.getVector(bmp.rect);
			len = pixels.length;
			
			posx = 0;
			posy = 0;
			
			for (i=0; i<len; i++) {
				var px : uint;
				
				px = pixels[i];
				if (px==WALL) {
					var r : Rectangle;
					
					r = findRect(pixels, bmp.width, bmp.height, posx, posy);
					level._walls.push(r);
				}
				else if (px == SPAWN) {
					level._spawn_point = new Point(posx, posy);
				}
				else if (px == HOOP) {
					var hoop : Hoop;
					
					hoop = new Hoop();
					hoop.position.x = posx;
					hoop.position.y = posy;
					hoop.rotation = Settings.HOOP_DEFAULT_ROTATION;
					level._hoops.push(hoop);
				}
				
				posx = (posx+1) % bmp.width;
				if (posx==0)
					posy++
			}
			
			return level;
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
			
			//trace(rect);
			
			return rect;
		}
	}
}