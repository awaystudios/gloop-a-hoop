package {

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	public class Wrapper extends Sprite
	{
		[Embed(source="../lib-swc/preload.swf", symbol="AwayMediaLogo")]
		private var AwayMediaLogoAsset:Class;

		[Embed(source="../lib-swc/preload.swf", symbol="FreakishKidLogo")]
		private var FreakishKidLogoAsset:Class;

		[Embed(source="../lib-swc/preload.swf", symbol="LoadingScreen")]
		private var LoadingScreenAsset:Class;

		private var _loader:Loader;
		private var _awayMediaLogo:Sprite;
		private var _freakishKidLogo:Sprite;
		private var _loadingScreen:Sprite;
		private var _activeScreen:Sprite;
		private var _screenTmr:Timer;
		private var _nextCallback:Function;
		private var _phase:uint;
		private var _frameCounter:uint;
		private var _loadingScreenTapText:Sprite;
		private var _loadingScreenProgressBar:Sprite;

		public function Wrapper() {
			super();

			// init stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			stage.addEventListener( Event.RESIZE, onStageResize );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onStageMouseDown );

			// retrieve graphics
			_awayMediaLogo = new AwayMediaLogoAsset();
			_freakishKidLogo = new FreakishKidLogoAsset();
			_loadingScreen = new LoadingScreenAsset();
			_loadingScreenTapText = _loadingScreen.getChildByName( "tap" ) as Sprite;
			_loadingScreenTapText.visible = false;
			_loadingScreenProgressBar = _loadingScreen.getChildByName( "bar" ) as Sprite;

			// init timer
			_screenTmr = new Timer( 2000, 1 );
			_screenTmr.addEventListener( TimerEvent.TIMER, onScreenTimerTick );

			// show first screen
			loadAwayMediaScreen();
		}

		private function loadAwayMediaScreen():void {
			displayScreen( _awayMediaLogo );
			_nextCallback = loadFreakishKidScreen;
			_screenTmr.reset();
			_screenTmr.start();
			_phase = 1;
		}

		private function loadFreakishKidScreen():void {
			displayScreen( _freakishKidLogo );
			_nextCallback = loadApp;
			_screenTmr.reset();
			_screenTmr.start();
			_phase = 2;
		}

		private function loadApp():void {

			// initialize loader and trigger load
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
			_loader.load( new URLRequest( "Main.swf" ) );

			// show loading screen
			displayScreen( _loadingScreen );
			_phase = 3;
		}

		private function displayScreen( screen:Sprite ):void {
			if( _activeScreen ) removeChild( _activeScreen );
			_activeScreen = screen;
			addChild( _activeScreen );
			onStageResize( null );
		}

		private function onScreenTimerTick( event:TimerEvent ):void {
			_nextCallback();
		}

		private function onStageResize( event:Event ):void {
			if( _activeScreen ) {
				_activeScreen.x = stage.stageWidth / 2;
				_activeScreen.y = stage.stageHeight / 2;
			}
		}

		private function onLoaderComplete( event:Event ):void {
			_loadingScreenProgressBar.visible = false;
			startApp();
		}

		private function startApp():void {
			_phase = 4;
			_loader.content.addEventListener( Event.COMPLETE, onAppInitialized );
			_loader.alpha = 0;
			_loader.mouseEnabled = _loader.mouseChildren = false;
			addChild( _loader );
		}

		private function onAppInitialized( event:Event ):void {
			_phase = 5;
			_loader.content.removeEventListener( Event.COMPLETE, onAppInitialized );
		}

		private function exposeApp():void {
			// remove active screen from the background
			_loadingScreenTapText.visible = true;
			_loader.mouseEnabled = _loader.mouseChildren = true;
			_loader.alpha = 1;
			removeChild( _activeScreen );
			cleanUp();
		}

		private function cleanUp():void {
			_activeScreen = null;
			_awayMediaLogo = null;
			_freakishKidLogo = null;
			_loadingScreenTapText = null;
			_loadingScreenProgressBar = null;
			stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, onStageMouseDown );
			stage.removeEventListener( Event.RESIZE, onStageResize );
			_screenTmr.removeEventListener( TimerEvent.TIMER, onScreenTimerTick );
			_screenTmr = null;
		}

		private function onLoaderProgress( event:ProgressEvent ):void {
			var progress:Number = event.bytesLoaded / event.bytesTotal;
			_loadingScreenProgressBar.scaleX = progress;
		}

		private function onStageMouseDown( event:MouseEvent ):void {
			switch( _phase ) {
				case 1:
					loadFreakishKidScreen();
					break;
				case 2:
					loadApp();
					break;
				case 4:
					startApp();
					break;
				case 5:
					exposeApp();
					break;
			}
		}

		private function onEnterFrame( event:Event ):void {
			_frameCounter++;
			switch( _phase ) {
				case 5:
					var mod:Number = _frameCounter % 35;
					_loadingScreenTapText.visible = mod > 5;
					break;
			}
		}
	}
}
