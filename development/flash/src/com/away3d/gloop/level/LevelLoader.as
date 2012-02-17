package com.away3d.gloop.level
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.AssetLoader;
	import away3d.materials.ColorMaterial;
	
	import com.away3d.gloop.gameobjects.Hoop;
	import com.away3d.gloop.gameobjects.Wall;
	import com.away3d.gloop.level.utils.SceneGraphIterator;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.sensors.Geolocation;
	import flash.utils.ByteArray;

	public class LevelLoader extends EventDispatcher
	{
		private var _scale : Number;
		private var _level : Level;
		
		public function LevelLoader(scale : Number = 1)
		{
			_scale = scale;
		}
		
		
		public function get loadedLevel() : Level
		{
			return _level;
		}
		
		
		public function load(req : URLRequest) : void
		{
			var loader : AssetLoader;
			
			reset();
			
			loader = new AssetLoader();
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader.load(req);
		}
		
		
		public function loadData(bytes : ByteArray) : void
		{
			var loader : AssetLoader;
			
			reset();
			
			loader = new AssetLoader();
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader.loadData(bytes, '');
		}
		
		
		private function reset() : void
		{
			_level = new Level();
		}
		
		
		private function parseWall(obj : ObjectContainer3D) : void
		{
			var mesh : Mesh;
			var wall : Wall;
			var min : Vector3D;
			var dim : Vector3D;
			
			mesh = Mesh(obj);
			min = mesh.bounds.min;
			dim = mesh.bounds.max.subtract(min);
			
			wall = new Wall(min.x, -min.y, dim.x, -dim.y);
			wall.physics.x = obj.x * _scale;
			wall.physics.y = -obj.y * _scale;
			wall.physics.rotation = -obj.rotationZ;
			
			_level.add(wall);
		}
		
		
		private function parseSpawnPoint(obj : ObjectContainer3D) : void
		{
			_level.spawnPoint.x = obj.x * _scale;
			_level.spawnPoint.y = -obj.y * _scale;
		}
		
		
		private function parseHoop(obj : ObjectContainer3D) : void
		{
			var hoop : Hoop;
			
			hoop = new Hoop(obj.x * _scale, -obj.y * _scale);
			_level.add(hoop);
		}
		
		
		private function parseSceneGraphObject(obj : ObjectContainer3D) : void
		{
			if (obj.extra && obj.extra.hasOwnProperty('gah_type')) {
				switch (obj.extra['gah_type']) {
					case 'wall':
						parseWall(obj);
						break;
					
					case 'spawn':
						parseSpawnPoint(obj);
						break;
					
					case 'hoop':
						parseHoop(obj);
						break;
				}
				
				// Non-visual object or placeholder
				if (obj.parent)
					obj.parent.removeChild(obj);
			}
			else {
				var mesh : Mesh
				
				obj.x *= _scale;
				obj.y *= _scale;
				
				mesh = obj as Mesh;
				if (mesh) {
					mesh.material = new ColorMaterial(Math.random() * 0xffffff);
				}
				
				// Visual object, add if not already parented
				if (!obj.parent)
					_level.scene.addChild(obj);
			}
		}
		
		
		private function onAssetComplete(ev : AssetEvent) : void
		{
			switch (ev.asset.assetType) {
				case AssetType.MESH:
				case AssetType.CONTAINER:
					parseSceneGraphObject( ObjectContainer3D(ev.asset) );
					break;
				
				case AssetType.GEOMETRY:
					Geometry(ev.asset).scale(_scale);
					break;
			}
		}
		
		
		private function onResourceComplete(ev : LoaderEvent) : void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}