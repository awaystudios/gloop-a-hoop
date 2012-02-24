package
{

	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	import com.away3d.gloop.gameobjects.hoops.RocketHoop;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.events.GameEvent;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.LevelLoader;
	import com.away3d.gloop.screens.game.GameScreen;
	import com.away3d.gloop.screens.LoadingScreen;
	import com.away3d.gloop.screens.ScreenStack;
	import com.away3d.gloop.screens.Screens;
	import com.away3d.gloop.screens.levelselect.LevelSelectScreen;
	import com.away3d.gloop.screens.win.WinScreen;
	import com.away3d.gloop.utils.HierarchyTool;
	import com.away3d.gloop.utils.SettingsLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	[SWF(width="1024", height="768", frameRate="60")]
	public class Main extends Sprite
	{
		private var _db:LevelDatabase;
		private var _stack:ScreenStack;
		private var _settings:SettingsLoader;
		
		[Embed('/../assets/gloop/flying/flying.awd', mimeType='application/octet-stream')]
		private var FlyingAWDAsset : Class;

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
			
			AssetLibrary.loadData(FlyingAWDAsset);
			
			var s:AwayStats = new AwayStats();
			s.x = stage.stageWidth - s.width;
			parent.addChild(s);

			_stack.gotoScreen( Screens.LOADING );
		}
		
		private function initSettings():void {
			_settings = new SettingsLoader(Settings);
		}
		
		private function initDb():void {
			_db = new LevelDatabase();
			_db.addEventListener( Event.COMPLETE, onDbComplete );
			_db.addEventListener( GameEvent.LEVEL_SELECT, onDbSelect );
			_db.addEventListener( GameEvent.LEVEL_LOSE, onDbLevelLose );
			_db.addEventListener( GameEvent.LEVEL_WIN, onDbLevelWin );
			_db.loadXml( 'assets/levels.xml' );
		}


		private function initStack():void {
			var w : Number, h : Number;
			
			w = stage.stageWidth;
			h = stage.stageHeight;
			
			_stack = new ScreenStack(w, h, this );
			_stack.addScreen( Screens.LOADING, new LoadingScreen() );
			_stack.addScreen( Screens.GAME, new GameScreen( _db ) );
			_stack.addScreen( Screens.LEVELS, new LevelSelectScreen( _db ) );
			_stack.addScreen( Screens.WIN, new WinScreen(_stack) );
		}
		
		
		protected function loadState(db : LevelDatabase) : void
		{
			// To be overridden in AIR version.
		}
		
		
		protected function saveState(xml : XML) : void
		{
			// To be overridden in AIR version and 
			// saved to device storage
			trace(xml.toXMLString());
		}
		
		

		private function onDbComplete( ev:Event ):void {
			loadState(_db);
			
			_stack.gotoScreen( Screens.LEVELS );
		}


		private function onDbSelect( ev:Event ):void {
			_stack.gotoScreen( Screens.LOADING );

			_db.selectedProxy.addEventListener( GameEvent.LEVEL_LOAD, onSelectedLevelLoad );
			_db.selectedProxy.load();
		}
		
		
		private function onDbLevelWin(ev : Event) : void
		{
			saveState( _db.getStateXml() );
			
			//_stack.gotoScreen(Screens.WIN);
		}
		
		
		private function onDbLevelLose(ev : Event) : void
		{
			saveState( _db.getStateXml() );
		}


		private function onSelectedLevelLoad( ev:Event ):void {
			_db.selectedProxy.removeEventListener(GameEvent.LEVEL_LOAD, onSelectedLevelLoad);
			_stack.gotoScreen( Screens.GAME );
		}


		private function onStageKeyUp( ev:KeyboardEvent ):void {
			if( ev.keyCode == Keyboard.R ) {
				_stack.gotoScreen( Screens.LOADING );
				_db.selectedProxy.addEventListener(GameEvent.LEVEL_LOAD, onSelectedLevelLoad);
				_db.selectedProxy.load( true );
			}
			
			// reload settings and restart level
			if ( ev.keyCode == Keyboard.F1) {
				_settings.reload();
				_settings.addEventListener(Event.COMPLETE, function(e:Event):void {
					_settings.removeEventListener(Event.COMPLETE, arguments.callee);
					_stack.gotoScreen( Screens.LOADING );
					_db.selectedProxy.addEventListener(GameEvent.LEVEL_LOAD, onSelectedLevelLoad);
					_db.selectedProxy.load( true );
				});
			}
			
			if( ev.keyCode == Keyboard.F2) _db.selectedProxy.reset();
			if( ev.keyCode == Keyboard.F3) _db.selectedProxy.level.setMode(Level.EDIT_MODE);
			if( ev.keyCode == Keyboard.F4) _db.selectedProxy.level.setMode(Level.PLAY_MODE);
			if (ev.keyCode == Keyboard.F5) _db.selectedProxy.level.queueHoopForPlacement(new RocketHoop);
		}
	}
}