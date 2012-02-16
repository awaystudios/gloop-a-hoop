package com.away3d.gloop.level
{
	import away3d.containers.Scene3D;
	
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.GameObject;
	
	import flash.geom.Point;
	
	import wck.World;

	public class Level
	{
		private var _scene : Scene3D;
		private var _world : World;
		
		private var _spawn_point :Point;
		private var _objects : Vector.<DefaultGameObject>;
		
		public function Level()
		{
			_scene = new Scene3D();
			_world = new World();
			_world.gravityY = 1;
			_spawn_point = new Point();
			_objects = new Vector.<DefaultGameObject>();
		}
		
		
		public function get spawnPoint() : Point
		{
			return _spawn_point;
		}
		
		public function get scene() : Scene3D
		{
			return _scene;
		}
		
		public function get world() : World
		{
			return _world;
		}
		
		
		public function add(object:DefaultGameObject):DefaultGameObject {
			_objects.push(object);
			if (object.physics) world.addChild(object.physics);
			if (object.mesh) scene.addChild(object.mesh.mesh);
			return object;
		}
		
		
		public function dispose() : void
		{
			var obj : DefaultGameObject;
			
			while (obj = _objects.pop()) {
				if (obj.mesh && obj.mesh.mesh && obj.mesh.mesh.parent)
					obj.mesh.mesh.parent.removeChild(obj.mesh.mesh);
				
				if (obj.physics && obj.physics.parent)
					obj.physics.parent.removeChild(obj.physics);
				
				obj.dispose();
			}
		}
	}
}