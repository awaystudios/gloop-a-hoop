package utils
{

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/*
	 * Loads a swf containing a library of assets.
	 * Guarantees a "shake-n-bake" connection with the library in which linked assets in the library's fla
	 * can be associated with classes in the application's framework.
	 */
	public class ShakeAndBakeConnector extends EventDispatcher
	{
		private var _urlLoader:URLLoader;
		private var _displayContext:Sprite;

		public function ShakeAndBakeConnector( displayContext:Sprite ) {
			_displayContext = displayContext;
		}

		public function connectURL( assetsSwfUrl:String ):void {
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener( Event.COMPLETE, onAssetsSwfLoaded, false, 0, true );
			_urlLoader.load( new URLRequest( assetsSwfUrl ) );
		}

		public function connectData( data:ByteArray ):void {
			var loader:Loader = new Loader();
			loader.loadBytes( data, new LoaderContext( false, ApplicationDomain.currentDomain ) );
			_displayContext.addEventListener( Event.ENTER_FRAME, firstFrameHandler, false, 0, true );
		}

		private function onAssetsSwfLoaded( event:Event ):void {
			_urlLoader.removeEventListener( Event.COMPLETE, onAssetsSwfLoaded );
			connectData( _urlLoader.data );
		}

		private function firstFrameHandler( event:Event ):void {
			_displayContext.removeEventListener( Event.ENTER_FRAME, firstFrameHandler );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
