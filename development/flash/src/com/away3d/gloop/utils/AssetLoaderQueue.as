package com.away3d.gloop.utils
{

	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AssetLoaderQueue extends EventDispatcher
	{
		private var _resources : Vector.<Class>;
		private var _nextResIdx : uint;
		
		public function AssetLoaderQueue()
		{
			super();
			
			_resources = new Vector.<Class>();
		}
		
		
		public function addResource(cls : Class) : void
		{
			_resources.push(cls);
		}
		
		
		public function load() : void
		{
			_nextResIdx = 0;
			
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
//			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete); // just for tracing out asset names

			loadNext();
		}

		private function onAssetComplete( event:AssetEvent ):void {
			trace( "loaded resource: " + event.asset.name );
		}
		
		
		private function loadNext() : void
		{
			
			if (_nextResIdx < _resources.length) {
				AssetLibrary.loadData(_resources[_nextResIdx++]);
			}
			else {
				AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		
		private function onResourceComplete(ev : LoaderEvent) : void
		{
			loadNext();
		}
	}
}