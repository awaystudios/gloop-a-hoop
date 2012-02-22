package
{

	import away3d.entities.Mesh;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.utils.SettingsLoader;

	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.LevelLoader;
	import com.away3d.gloop.screens.GameScreen;
	import com.away3d.gloop.screens.LoadingScreen;
	import com.away3d.gloop.screens.ScreenStack;
	import com.away3d.gloop.screens.Screens;
	import com.away3d.gloop.screens.levelselect.LevelSelectScreen;
	import com.away3d.gloop.utils.HierarchyTool;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	[SWF(width="768", height="1024", frameRate="60")]
	public class Main extends Sprite
	{
		private var _db:LevelDatabase;
		private var _stack:ScreenStack;
		private var _settings:SettingsLoader;

		public function Main() {
			addEventListener( Event.ADDED_TO_STAGE, init, false, 0, true );
		}


		private function init( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, init );

			Loader3D.enableParser( AWD2Parser );

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( KeyboardEvent.KEY_UP, onStageKeyUp );

			initSettings();
			initDb();
			initStack();

			_stack.gotoScreen( Screens.LOADING );
		}
		
		private function initSettings():void {
			_settings = new SettingsLoader(Settings);
		}
		
		private function initDb():void {
			_db = new LevelDatabase();
			_db.addEventListener( Event.COMPLETE, onDbComplete );
			_db.addEventListener( Event.SELECT, onDbSelect );
			_db.loadXml( 'assets/levels.xml' );
		}


		private function initStack():void {
			_stack = new ScreenStack( this );
			_stack.addScreen( Screens.LOADING, new LoadingScreen() );
			_stack.addScreen( Screens.GAME, new GameScreen( _db ) );
			_stack.addScreen( Screens.LEVELS, new LevelSelectScreen( _db ) );
		}


		private function onDbComplete( ev:Event ):void {
			_stack.gotoScreen( Screens.LEVELS );
		}


		private function onDbSelect( ev:Event ):void {
			_stack.gotoScreen( Screens.LOADING );

			_db.selectedProxy.addEventListener( Event.COMPLETE, onLevelComplete );
			_db.selectedProxy.load();
		}


		private function onLevelComplete( ev:Event ):void {
			var gloop:Gloop;
			var loader:LevelLoader;
			
			gloop = new Gloop(_db.selectedProxy.level.spawnPoint.x, _db.selectedProxy.level.spawnPoint.y);
			
			// TODO: this is a temporary provision of meshes for gloop to splat on
			var splattables:Vector.<Mesh> = new Vector.<Mesh>()
			for( var i:uint, len:uint = _db.selectedProxy.level.scene.numChildren; i < len; ++i ) {
				splattables = splattables.concat( HierarchyTool.getAllMeshesInHierarchy( _db.selectedProxy.level.scene.getChildAt( i ) ) );
			}
			gloop.splat.splattables = splattables;

			_db.selectedProxy.level.add( gloop );

			_stack.gotoScreen( Screens.GAME );
		}


		private function onStageKeyUp( ev:KeyboardEvent ):void {
			if( ev.keyCode == Keyboard.R ) {
				_stack.gotoScreen( Screens.LOADING );
				_db.selectedProxy.load( true );
			}
			
			if ( ev.keyCode == Keyboard.F1) {
				_settings.reload();
				_settings.addEventListener(Event.COMPLETE, function(e:Event):void {
					_settings.removeEventListener(Event.COMPLETE, arguments.callee);
					_stack.gotoScreen( Screens.LOADING );
					_db.selectedProxy.load( true );
				});
			}
		}
		
	}
}