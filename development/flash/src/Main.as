package
{
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelParser;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class Main extends Sprite
	{
		[Embed("/../assets/levels/test/testlevel.awd", mimeType="application/octet-stream")]
		private var TestLevelAWDAsset : Class;
		
		public function Main()
		{
			var loader : Loader3D;
			
			Loader3D.enableParser(AWD2Parser);
			
			loader = new Loader3D();
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader.loadData(TestLevelAWDAsset);
		}
		
		
		private function onResourceComplete(ev : LoaderEvent) : void
		{
			var gloop : Gloop;
			var level : Level;
			var loader : Loader3D;
			var parser : LevelParser;
			
			loader = Loader3D(ev.currentTarget);
			
			parser = new LevelParser();
			level = parser.parseContainer(loader);
			
			trace(level.spawnPoint);
		}
	}
}