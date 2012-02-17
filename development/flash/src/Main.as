package
{
	import away3d.containers.View3D;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import wck.WCK;
	
	[SWF(width="768", height="1024", frameRate="60")]
	public class Main extends Sprite
	{
		private var _doc : WCK;
		private var _level : Level;
		private var _view : View3D;
		
		public function Main()
		{
			Loader3D.enableParser(AWD2Parser);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
			
			_doc = new WCK();
			_doc.x = 80;
			_doc.y = 80;
			_doc.scaleX = 0.2;
			_doc.scaleY = 0.2;
			addChild(_doc);
			
			_view = new View3D();
			_view.antiAlias = 4;
			addChild(_view);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			loadLevel();
		}
		
		
		private function loadLevel() : void
		{
			if (_level) {
				_level.dispose();
				_level.world.parent.removeChild(_level.world);
			}
			
			
			var loader : LevelLoader;
			
			loader = new LevelLoader(50);
			loader.addEventListener(Event.COMPLETE, onLevelComplete);
			loader.load(new URLRequest("assets/levels/testlevel.awd"));
		}
		
		
		private function onLevelComplete(ev : Event) : void
		{
			var gloop : Gloop;
			var loader : LevelLoader;
			
			loader = LevelLoader(ev.currentTarget);
			_level = loader.loadedLevel;
			
			gloop = new Gloop();
			gloop.physics.x = _level.spawnPoint.x;
			gloop.physics.y = _level.spawnPoint.y;
			_level.add(gloop);
			
			_doc.addChild(_level.world);
			_view.scene = _level.scene;
			
			trace(_level.spawnPoint);
		}
		
		
		private function onStageKeyUp(ev : KeyboardEvent) : void
		{
			if (ev.keyCode == Keyboard.R) {
				loadLevel();
			}
		}
		
		
		private function onEnterFrame(ev : Event) : void
		{
			if (_level)
				_level.update();
			
			_view.camera.x = stage.mouseX - stage.stageWidth/2;
			_view.camera.y = stage.mouseY - stage.stageHeight/2;
			_view.camera.lookAt(new Vector3D());
			_view.render();
		}
	}
}