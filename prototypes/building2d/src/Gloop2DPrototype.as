package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight;
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
	
	import uk.co.awamedia.gloop.Settings;
	import uk.co.awamedia.gloop.events.LevelInteractionEvent;
	import uk.co.awamedia.gloop.gameobjects.Gloop;
	import uk.co.awamedia.gloop.gameobjects.Hoop;
	import uk.co.awamedia.gloop.levels.Level;
	import uk.co.awamedia.gloop.levels.LevelBitmapParser;
	
	[SWF(width="1024", height="768", frameRate="60")]
	public class Gloop2DPrototype extends Sprite
	{
		private var _level : Level;
		private var _light : DirectionalLight;
		
		private var _bmp : BitmapData;
		private var _view : View3D;
		private var _gloop : Gloop;
		private var _gloop_obj : Mesh;
		
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
			var parser : LevelBitmapParser;
			
			parser = new LevelBitmapParser();
			_level = parser.parseBitmap(Bitmap(new LevelBitmapAsset).bitmapData);
			_level.addEventListener(LevelInteractionEvent.DOWN, onLevelInteractionEvent);
			_level.addEventListener(LevelInteractionEvent.MOVE, onLevelInteractionEvent);
			_level.addEventListener(LevelInteractionEvent.RELEASE, onLevelInteractionEvent);
			
			_light = new DirectionalLight(1, -1, 2);
			_light.ambient = 0.6;
			_light.specular = 0.7;
			ctr = _level.construct([_light], Settings.GRID_SIZE);
			
			_view.scene.addChild(ctr);
		}
		
		
		private function initGloop() : void
		{
			_gloop_obj = new Mesh(new SphereGeometry(10), new ColorMaterial(0x00aa00));
			_gloop_obj.mouseEnabled = true;
			_gloop_obj.material.lightPicker = new StaticLightPicker([_light]);
			_gloop_obj.addEventListener(MouseEvent3D.MOUSE_DOWN, onGloopMouseDown);
			_view.scene.addChild(_gloop_obj);
			
			_gloop = new Gloop(_gloop_obj);
			_gloop.position.x = _level.spawnPoint.x;
			_gloop.position.y = _level.spawnPoint.y;
			
			_gloop.update();
			
			_idle = true;
		}
		
		private function onEnterFrame(ev : Event) : void
		{
			var cam_tx : Number;
			
			if (!_idle) {
				
				_gloop.update();
				_gloop.collideWithLevel(_level);
				
				for each(var hoop:Hoop in _level.hoops) {
					if (!hoop.enabled) continue;				
					if (testHoopCollision(hoop)) hoop.activate(_gloop);
				}
				
			}
			
			_level.update();
			
			_gloop_obj.rotationZ = Math.atan2(-_gloop.speed.y, _gloop.speed.x) * 180/Math.PI;
 			_gloop_obj.scaleX = 1 + 0.2 * _gloop.speed.length;
			_gloop_obj.scaleY = 1/_gloop_obj.scaleX;
			_gloop_obj.scaleZ = 1/_gloop_obj.scaleX;
				
			cam_tx = _gloop_obj.x - _gloop.speed.x * 100;
			_view.camera.x += 0.1 * (cam_tx - _view.camera.x);
			_view.camera.y += 0.3 * ((_gloop_obj.y+200) - _view.camera.y);
			_view.camera.lookAt(_gloop_obj.position);
			
			_view.render();
		}
		
		
		private function testHoopCollision(hoop:Hoop):Boolean {
			var distance:Number = Point.distance(hoop.position, _gloop.position);
			if (distance > hoop.radius + _gloop.radius) return false;
			
			// a vector representing the slant of the hoop
			var hoop2:Point = new Point(hoop.position.x + hoop.slope.x, hoop.position.y - hoop.slope.y);
			
			// work out the normal for that vector (hacky)
			var tmp:Point = hoop.position.subtract(hoop2);
			tmp.normalize(1);
			var b:Point = new Point(-tmp.y, tmp.x);
			
			// a vector representing the distance between the hoop and the gloop
			var a	:Point = hoop.position.subtract(_gloop.position);
			
			// get the dot product between the normal for the hoop slant and the gloop/hoop distance
			// positive/negative values tell us if we're coming in from the front or back
			// we don't care too much about that now so we use Math.abs to get the real value
			var dp:Number = Math.abs(a.x * b.x + a.y * b.y);
			
			// if the dotproduct is more than the gloops radius, we're not colliding
			if (dp > _gloop.radius) return false;
			
			return true;
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
			_power.y = -(ev.stageY - _drag_start.y);
			
			if (_power.length > 1.5)
				_power.normalize(1.5);
		}
		
		
		private function onStageMouseUp(ev : MouseEvent) : void
		{
			_idle = false;
			_gloop.speed.x = _power.x;
			_gloop.speed.y = _power.y;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}
		
		private function nudge(x:Number, y:Number):void {
			_gloop.position.x += x;
			_gloop.position.y += y;
			_gloop.speed.normalize(0);
			_gloop.update();
			
			for each(var hoop:Hoop in _level.hoops) {
				if (testHoopCollision(hoop)) {
					hoop.setColor(0x000000);
				} else {
					hoop.setColor(0xff0000);
				}
			}
		}
		
		private function onStageKey(ev : KeyboardEvent) : void
		{
			switch (ev.keyCode) {
				case Keyboard.SPACE:
					_gloop.position.x = _level.spawnPoint.x;
					_gloop.position.y = _level.spawnPoint.y;
					_gloop.speed.normalize(0);
					_gloop.update();
					_idle = true;
					break;
				case Keyboard.UP:
					nudge(0, -1);
					break;
				case Keyboard.DOWN:
					nudge(0, 1);
					break;
				case Keyboard.LEFT:
					nudge(-1, 0);
					break;
				case Keyboard.RIGHT:
					nudge(1, 0);
					break;
			}
		}
		
		
		private function onLevelInteractionEvent(ev : LevelInteractionEvent) : void
		{
			trace(ev.type, ev.gridX, ev.gridY);
		}
	}
}