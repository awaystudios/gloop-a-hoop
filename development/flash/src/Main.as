package
{
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelParser;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import wck.WCK;
	
	[SWF(frameRate="60")]
	public class Main extends Sprite
	{
		private var _level : Level;
		
		public function Main()
		{
			Loader3D.enableParser(AWD2Parser);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
			
			loadLevel();
		}
		
		
		private function loadLevel() : void
		{
			if (_level)
				_level.dispose();
			
			var loader : Loader3D;
			loader = new Loader3D(false);
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader.load(new URLRequest("../assets/levels/test/testlevel.awd"));
		}
		
		
		private function onResourceComplete(ev : LoaderEvent) : void
		{
			var doc : WCK;
			var gloop : Gloop;
			var loader : Loader3D;
			var parser : LevelParser;
			
			loader = Loader3D(ev.currentTarget);
			
			parser = new LevelParser(30);
			_level = parser.parseContainer(loader);
			
			gloop = new Gloop();
			gloop.physics.x = _level.spawnPoint.x;
			gloop.physics.y = _level.spawnPoint.y;
			_level.add(gloop);
			
			doc = new WCK();
			doc.x = stage.stageWidth/2;
			doc.y = stage.stageHeight/2;
			addChild(doc);
			
			doc.addChild(_level.world);
			
			trace(_level.spawnPoint);
		}
		
		
		private function onStageKeyUp(ev : KeyboardEvent) : void
		{
			if (ev.keyCode == Keyboard.R) {
				loadLevel();
			}
		}
	}
}