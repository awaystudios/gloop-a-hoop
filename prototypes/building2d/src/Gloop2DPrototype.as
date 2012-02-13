package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SphereGeometry;
	import uk.co.awamedia.gloop.Settings;
	
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
			
			_parser = new LevelBitmapParser(Settings.GRID_SIZE);
			ctr = _parser.parseBitmap(_bmp);
			
			_view.scene.addChild(ctr);
		}
		
		
		private function initGloop() : void
		{
			_gloop_obj = new Mesh(new SphereGeometry(10), new ColorMaterial(0x00aa00));
			_gloop_obj.mouseEnabled = true;
			_gloop_obj.material.lightPicker = new StaticLightPicker([_parser.light]);
			_gloop_obj.addEventListener(MouseEvent3D.MOUSE_DOWN, onGloopMouseDown);
			_view.scene.addChild(_gloop_obj);
			
			_gloop = new Gloop(_gloop_obj);
			_gloop.position.x = _parser.spawnPoint.x;
			_gloop.position.y = _parser.spawnPoint.y;
			
			_gloop.update();
			
			_idle = true;
		}
		
		
		private function testCollision(worldX : Number, worldY : Number) : Boolean
		{
			var gridx:int = Math.round(worldX / Settings.GRID_SIZE);
			var gridy:int = -Math.round(worldY / Settings.GRID_SIZE);
			
			if (gridx >= _bmp.width || gridx < 0 || gridy < 0 || gridy > _bmp.height-1)
				return true;
			
			return _bmp.getPixel(gridx, gridy) == 0;
		}
		
		private function testAndResolveCollision(offsetX:Number, offsetY:Number):Boolean {
			if (testCollision(_gloop.position.x + offsetX, _gloop.position.y + offsetY)) {
					
				var direction:Point = _gloop.speed.clone();
				
				// hack to only resolve in the offset direction. hacktastic!
				if (offsetX != 0) direction.y = 0;
				else if (offsetY != 0) direction.x = 0;
				
				direction.normalize(Settings.COLLISION_STEP);
				var stepsBack:int = 1;
				
				while (testCollision(_gloop.position.x + offsetX - direction.x * stepsBack, _gloop.position.y + offsetY - direction.y * stepsBack)) {
					stepsBack++;
					
					// something is messed up, bail!
					if (stepsBack > 10) return true;
				}
				
				_gloop.position.x -= direction.x * stepsBack;
				_gloop.position.y -= direction.y * stepsBack;
					
				return true;
			}	
			
			return false;
		}
		
		private function onEnterFrame(ev : Event) : void
		{
			if (!_idle) {
				
				_gloop.update();
				
				if (testAndResolveCollision(-Settings.GLOOP_SIZE, 0) && _gloop.speed.x < 0) _gloop.speed.x *= -Settings.GLOOP_BOUNCE_FRICTION;
				if (testAndResolveCollision( Settings.GLOOP_SIZE, 0) && _gloop.speed.x > 0) _gloop.speed.x *= -Settings.GLOOP_BOUNCE_FRICTION;
				if (testAndResolveCollision(0, -Settings.GLOOP_SIZE) && _gloop.speed.y < 0) _gloop.speed.y *= -Settings.GLOOP_BOUNCE_FRICTION;
				if (testAndResolveCollision(0,  Settings.GLOOP_SIZE) && _gloop.speed.y > 0) _gloop.speed.y *= -Settings.GLOOP_BOUNCE_FRICTION;				
				
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
			
			if (_power.length > 15)
				_power.normalize(15);
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
					_gloop.position.x = _parser.spawnPoint.x;
					_gloop.position.y = _parser.spawnPoint.y;
					_gloop.speed.normalize(0);
					_gloop.update();
					_idle = true;
					break;
			}
		}
	}
}