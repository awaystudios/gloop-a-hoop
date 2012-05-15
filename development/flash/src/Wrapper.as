package {

	import com.away3d.gloop.events.WrapperEvent;
	import com.pixelbath.ui.Slice9Bitmap;
	
	import flash.display.Bitmap;
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

		[Embed(source="../lib-swc/preload.swf", symbol="LoadingScreenAsset")]
		private var LoadingScreenAsset:Class;
		
		[Embed(source="/../assets/images/Title Loading Bar Screen.png")]
		private var LoadBarBitmap:Class;
		
		private var _loader:Loader;
		private var _app:Sprite;
		private var _awayMediaLogo:Sprite;
		private var _freakishKidLogo:Sprite;
		private var _loadingScreen:Sprite;
		private var _activeScreen:Sprite;
		private var _screenTmr:Timer;
		private var _nextCallback:Function;
		private var _phase:uint;
		private var _frameCounter:uint;
		private var _loadingScreenLoadingText:Sprite;
		private var _loadingScreenTapText:Sprite;
		private var _loadingScreenProgressBar:Sprite;
		private var _loadingScreenProgressBarBitmap:Slice9Bitmap;
		private var _progress:Number = 0;
		
		public function Wrapper() {
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( event : Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
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
			_loadingScreenLoadingText = _loadingScreen.getChildByName( "loading" ) as Sprite;
			_loadingScreenTapText = _loadingScreen.getChildByName( "tap" ) as Sprite;
			_loadingScreenTapText.visible = false;
			_loadingScreenProgressBar = _loadingScreen.getChildByName( "bar" ) as Sprite;
			var bmp:Bitmap = new LoadBarBitmap();
			
			_loadingScreenProgressBar.addChild(_loadingScreenProgressBarBitmap = new Slice9Bitmap(new LoadBarBitmap()));
			_loadingScreenProgressBar.visible = false;
			
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

		private function loadApp():void
		{
			_screenTmr.removeEventListener( TimerEvent.TIMER, onScreenTimerTick );
			_screenTmr = null;
			
			if (this == root) {
				
				// initialize loader and trigger load
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
				_loader.load( new URLRequest( "Main.swf" ) );
			} else {
				_app = root as Sprite;
				_app.addEventListener( Event.COMPLETE, onAppInitialized );
				dispatchEvent(new WrapperEvent(WrapperEvent.WRAPPER_DONE));
			}
				

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
				_activeScreen.width = stage.stageWidth;
				_activeScreen.height = stage.stageWidth*768/1024;
			}
		}

		private function onLoaderComplete( event:Event ):void {
			_loadingScreenProgressBar.visible = false;
			startApp();
		}

		private function startApp():void {
			_phase = 4;
			_app = _loader.content as Sprite
			_app.addEventListener( Event.COMPLETE, onAppInitialized );
			_app.alpha = 0;
			_app.mouseEnabled = _app.mouseChildren = false;
			addChild( _app );
		}

		private function onAppInitialized( event:Event ):void {
			_phase = 5;
			_loadingScreenLoadingText.visible = false;
			_app.removeEventListener( Event.COMPLETE, onAppInitialized );
		}

		private function exposeApp():void {
			// remove active screen from the background
			_loadingScreenTapText.visible = true;
			_app.mouseEnabled = _app.mouseChildren = true;
			_app.alpha = 1;
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
		}

		private function onLoaderProgress( event:ProgressEvent ):void {
			_progress = event.bytesLoaded / event.bytesTotal;
			_loadingScreenProgressBar.visible = true;
		}

		private function onStageMouseDown( event:MouseEvent ):void {
			switch( _phase ) {
				case 1:
					loadFreakishKidScreen();
					break;
				case 2:
					loadApp();
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
				case 3:
					_loadingScreenProgressBarBitmap.setSize(uint(595*_progress), 33);
					break;
			}
		}
	}
}
