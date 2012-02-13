package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SphereGeometry;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import uk.co.awamedia.gloop.gameobjects.Gloop;
	import uk.co.awamedia.gloop.levels.LevelBitmapParser;
	
	[SWF(width="1024", height="768", frameRate="60")]
	public class Gloop2DPrototype extends Sprite
	{
		private var _bmp : BitmapData;
		private var _view : View3D;
		private var _gloop : Gloop;
		private var _gloop_obj : Mesh;
		
		private var _parser : LevelBitmapParser;
		private var _drag_start : Point;
		private var _power : Point;
		
		private var _idle : Boolean;
		
		[Embed("/../assets/level.png")]
		private var LevelBitmapAsset : Class;
		
		public function Gloop2DPrototype()
		{
			super();
			
			init();
		}
		
		
		private function init() : void
		{
			init3d();
			initLevel();
			initGloop();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKey);
		}
		
		
		private function init3d() : void
		{
			_view = new View3D();
			_view.camera.z = -500;
			addChild(_view);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		private function initLevel() : void
		{
			var ctr : ObjectContainer3D;
			
			_bmp = Bitmap(new LevelBitmapAsset).bitmapData;
			
			_parser = new LevelBitmapParser();
			ctr = _parser.parseBitmap(_bmp);
			
			_view.scene.addChild(ctr);
		}
		
		
		private function initGloop() : void
		{
			_gloop_obj = new Mesh(new SphereGeometry(10), new ColorMaterial(0x00aa00));
			_gloop_obj.mouseEnabled = true;
			_gloop_obj.x = _parser.spawnPoint.x;
			_gloop_obj.y = _parser.spawnPoint.y;
			_gloop_obj.material.lightPicker = new StaticLightPicker([_parser.light]);
			_gloop_obj.addEventListener(MouseEvent3D.MOUSE_DOWN, onGloopMouseDown);
			_view.scene.addChild(_gloop_obj);
			
			_gloop = new Gloop(_gloop_obj);
			
			_idle = true;
		}
		
		
		private function collision(gridx : Number, gridy : Number) : Boolean
		{
			var px : uint;
			
			if (gridx >= _bmp.width || gridx < 0 || gridy < 0 || gridy > _bmp.height-1)
				return false;
			
			px = _bmp.getPixel(gridx, gridy);
			return (px==0);
		}
		
		
		private function onEnterFrame(ev : Event) : void
		{
			var posx : Number;
			var posy : Number;
			var gridx : Number;
			var gridy : Number;
			
			if (!_idle) {
				if (_gloop.speed.y > -20)
					_gloop.speed.y -= 0.1;
				
				posx = _gloop_obj.x + _gloop.speed.x;
				posy = _gloop_obj.y + _gloop.speed.y;
				
				gridx = Math.round(posx/10);
				gridy = -Math.round(posy/10);
				if (collision(gridx, gridy)) {
					var dirx : Number, diry : Number;
					
					dirx = diry = 1;
					
					if (collision(gridx+1, gridy) || collision(gridx-1, gridy))
						diry = -0.8;
					
					if (collision(gridx, gridy+1) || collision(gridx, gridy-1))
						dirx = -0.8;
					
					_gloop.speed.x *= dirx * 0.9;
					_gloop.speed.y *= diry * 0.9;
				}
				
				_gloop.update();
			}
				
			_view.camera.x += 0.3 * (_gloop_obj.x - _view.camera.x);
			_view.camera.y += 0.3 * ((_gloop_obj.y+200) - _view.camera.y);
			_view.camera.lookAt(_gloop_obj.position);
			
			_view.render();
		}
		
		
		private function onGloopMouseDown(ev : MouseEvent3D) : void
		{
			_power = new Point();
			_drag_start = new Point(stage.mouseX, stage.mouseY);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		
		private function onStageMouseMove(ev : MouseEvent) : void
		{
			_power.x = -(ev.stageX - _drag_start.x);
			_power.y = ev.stageY - _drag_start.y;
			
			if (_power.length > 10)
				_power.normalize(10);
		}
		
		
		private function onStageMouseUp(ev : MouseEvent) : void
		{
			_idle = false;
			_gloop.speed.x = _power.x;
			_gloop.speed.y = _power.y;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}
		
		
		private function onStageKey(ev : KeyboardEvent) : void
		{
			switch (ev.keyCode) {
				case Keyboard.SPACE:
					_gloop_obj.x = _parser.spawnPoint.x;
					_gloop_obj.y = _parser.spawnPoint.y;
					_gloop.speed.normalize(0);
					_idle = true;
					break;
			}
		}
	}
}