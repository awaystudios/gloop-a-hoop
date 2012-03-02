package
{

	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.library.utils.AssetLibraryIterator;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.Max3DSParser;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.events.GameEvent;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.hoops.RocketHoop;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.LevelLoader;
	import com.away3d.gloop.screens.LoadingScreen;
	import com.away3d.gloop.screens.ScreenStack;
	import com.away3d.gloop.screens.Screens;
	import com.away3d.gloop.screens.StartScreen;
	import com.away3d.gloop.screens.chapterselect.ChapterSelectScreen;
	import com.away3d.gloop.screens.game.GameScreen;
	import com.away3d.gloop.screens.levelselect.LevelSelectScreen;
	import com.away3d.gloop.screens.settings.SettingsScreen;
	import com.away3d.gloop.screens.win.WinScreen;
	import com.away3d.gloop.utils.AssetLoaderQueue;
	import com.away3d.gloop.utils.EmbeddedResources;
	import com.away3d.gloop.utils.HierarchyTool;
	import com.away3d.gloop.utils.SettingsLoader;
	import com.away3d.gloop.utils.StateSaveManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;

	[SWF(width="1024", height="768", frameRate="30")]
	public class Main extends Sprite
	{
		private var _w : Number;
		private var _h : Number;
		
		private var _queue : AssetLoaderQueue;
		
		private var _db:LevelDatabase;
		private var _stack:ScreenStack;
		private var _settings:SettingsLoader;
		
		private var _view : View3D;
		
		protected var _stateMgr : StateSaveManager;

		public function Main()
		{
			init();
		}
		
		
		private function init() : void
		{
			var man : String;
			var sim : Boolean;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( KeyboardEvent.KEY_UP, onStageKeyUp );
			
			// Running in simulator?
			man = Capabilities.manufacturer;
			sim = (man.indexOf('Win')>=0 || man.indexOf('Mac')>=0);
			
			_w = sim? stage.stageWidth : stage.fullScreenWidth;
			_h = sim? stage.stageHeight : stage.fullScreenHeight;
			
			if (_h > _w) {
				var tmp : Number = _w;
				_w = _h;
				_h = tmp;
			}
			
			_view = new View3D();
			_view.width = _w;
			_view.height = _h;
			addChild(_view);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			// Should be reset to other state manager by AIR app
			_stateMgr = new StateSaveManager();

			initSettings();
			initDb();
			initStack();
			
			loadAssets();
		}
		
		private function initSettings():void {
			_settings = new SettingsLoader(Settings);
		}
		
		private function initDb():void {
			_db = new LevelDatabase();
			_db.addEventListener( Event.COMPLETE, onDbComplete );
			_db.addEventListener( GameEvent.CHAPTER_SELECT, onDbChapterSelect );
			_db.addEventListener( GameEvent.LEVEL_SELECT, onDbLevelSelect );
			_db.addEventListener( GameEvent.LEVEL_LOSE, onDbLevelLose );
			_db.addEventListener( GameEvent.LEVEL_WIN, onDbLevelWin );
		}


		private function initStack():void {
			_stack = new ScreenStack(_w, _h, this );
			_stack.addScreen( Screens.LOADING, new LoadingScreen() );
			_stack.addScreen( Screens.START, new StartScreen(_stack) );
			_stack.addScreen( Screens.SETTINGS, new SettingsScreen(_stack, _stateMgr) );
			_stack.addScreen(Screens.GAME, new GameScreen(_db, _stack, _view));
			_stack.addScreen( Screens.CHAPTERS, new ChapterSelectScreen( _db, _stack ) );
			_stack.addScreen( Screens.LEVELS, new LevelSelectScreen( _db, _stack ) );
			_stack.addScreen( Screens.WIN, new WinScreen(_db, _stack) );
		}
		
		
		
		private function loadState(db : LevelDatabase) : void
		{
			_stateMgr.loadState(db);
		}
		
		
		private function saveState(xml : XML) : void
		{
			_stateMgr.saveState(xml);
		}
		
		
		private function loadAssets() : void
		{
			AssetLibrary.enableParser( AWD2Parser );
			AssetLibrary.enableParser( Max3DSParser );
			
			_stack.gotoScreen(Screens.LOADING);
			
			_queue = new AssetLoaderQueue();
			_queue.addResource(EmbeddedResources.FlyingAWDAsset);
			_queue.addResource(EmbeddedResources.GloopSplat3DSAsset);
			_queue.addResource(EmbeddedResources.Cannon3DSAsset);
			_queue.addResource(EmbeddedResources.Fan3DSAsset);
			_queue.addResource(EmbeddedResources.Button3DSAsset);
			_queue.addResource(EmbeddedResources.Target3DSAsset);
			_queue.addResource(EmbeddedResources.Star3DSAsset);
			_queue.addResource(EmbeddedResources.Hoop3DSAsset);
			_queue.addEventListener(Event.COMPLETE, onAssetsComplete);
			_queue.load();
		}
		
		
		private function onAssetsComplete(ev : Event) : void
		{
			var it : AssetLibraryIterator;
			var mesh : Mesh;
			
			// Get rid of meshes to avoid having to clone geometries
			// to circumvent issues with material/animation sharing.
			it = AssetLibrary.createIterator(AssetType.MESH);
			while (mesh = Mesh(it.next())) {
				AssetLibrary.removeAsset(mesh, false);
				mesh.material = null;
				mesh.geometry = null;
				mesh.dispose();
			}
			
			// Load levels
			_db.loadXml( 'assets/levels.xml' );
		}
		

		private function onDbComplete( ev:Event ):void {
			loadState(_db);
			
			_stack.gotoScreen(Screens.START);
			//_db.selectLevel(_db.chapters[0].levels[0]);
		}
		
		
		private function onDbChapterSelect(ev : GameEvent) : void
		{
			_stack.gotoScreen( Screens.LEVELS );
		}


		private function onDbLevelSelect(ev : GameEvent):void {
			_stack.gotoScreen(Screens.LOADING);

			_db.selectedLevelProxy.addEventListener( GameEvent.LEVEL_LOAD, onSelectedLevelLoad );
			_db.selectedLevelProxy.load();
		}
		
		
		private function onDbLevelWin(ev : Event) : void
		{
			saveState( _db.getStateXml() );
			
			_stack.gotoScreen(Screens.WIN);
		}
		
		
		private function onDbLevelLose(ev : Event) : void
		{
			saveState( _db.getStateXml() );
		}


		private function onSelectedLevelLoad( ev:Event ):void {
			_db.selectedLevelProxy.removeEventListener(GameEvent.LEVEL_LOAD, onSelectedLevelLoad);
			_stack.gotoScreen( Screens.GAME );
		}


		private function onStageKeyUp( ev:KeyboardEvent ):void {
			if( ev.keyCode == Keyboard.R ) {
				_stack.gotoScreen( Screens.LOADING );
				_db.selectedLevelProxy.addEventListener(GameEvent.LEVEL_LOAD, onSelectedLevelLoad);
				_db.selectedLevelProxy.load( true );
			}
			
			// reload settings and restart level
			if ( ev.keyCode == Keyboard.F1) {
				_settings.reload();
				_settings.addEventListener(Event.COMPLETE, function(e:Event):void {
					_settings.removeEventListener(Event.COMPLETE, arguments.callee);
					_stack.gotoScreen( Screens.LOADING );
					_db.selectedLevelProxy.addEventListener(GameEvent.LEVEL_LOAD, onSelectedLevelLoad);
					_db.selectedLevelProxy.load( true );
				});
			}
			
			if( ev.keyCode == Keyboard.F2) _db.selectedLevelProxy.reset();
			if( ev.keyCode == Keyboard.F3) _db.selectedLevelProxy.level.setMode(Level.EDIT_MODE);
			if( ev.keyCode == Keyboard.F4) _db.selectedLevelProxy.level.setMode(Level.PLAY_MODE);
			if (ev.keyCode == Keyboard.F5) _db.selectedLevelProxy.level.queueHoopForPlacement(new RocketHoop);
		}
		
		
		private function onEnterFrame(ev : Event) : void
		{
			_view.render();
		}
	}
}