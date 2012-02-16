package com.away3d.gloop.level
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	
	import com.away3d.gloop.gameobjects.Wall;
	import com.away3d.gloop.level.utils.SceneGraphIterator;
	
	import flash.geom.Vector3D;

	public class LevelParser
	{
		private var _scale : Number;
		
		public function LevelParser(scale : Number = 1)
		{
			_scale = scale;
		}
		
		
		public function parseContainer(ctr : ObjectContainer3D) : Level
		{
			var level : Level;
			var it : SceneGraphIterator;
			var obj : ObjectContainer3D;
			
			level = new Level();
			
			it = new SceneGraphIterator(ctr);
			while (obj = it.next()) {
				if (obj.extra && obj.extra.hasOwnProperty('gloop_type')) {
					switch (obj.extra['gloop_type']) {
						case 'wall':
							parseWall(level, obj);
							break;
						
						case 'spawn':
							parseSpawnPoint(level, obj);
							break;
						
						case 'hoop':
							parseHoop(level, obj);
							break;
					}
				}
				else {
					// Visual object, add if
					// if already parented
					if (!obj.parent)
						level.scene.addChild(obj);
				}
			}
			
			return level;
		}
		
		
		private function parseWall(level : Level, obj : ObjectContainer3D) : void
		{
			var mesh : Mesh;
			var wall : Wall;
			var min : Vector3D;
			var dim : Vector3D;
			
			mesh = Mesh(obj);
			min = mesh.bounds.min;
			dim = mesh.bounds.max.subtract(min);
			
			wall = new Wall(min.x, min.y, dim.x, dim.y)
			wall.physics.x = obj.x;
			wall.physics.y = obj.y;
			wall.physics.rotation
			
			level.world.addChild(wall.physics);
		}
		
		
		private function parseSpawnPoint(level : Level, obj : ObjectContainer3D) : void
		{
			level.spawnPoint.x = obj.x * _scale;
			level.spawnPoint.y = obj.y * _scale;
		}
		
		
		private function parseHoop(level : Level, obj : ObjectContainer3D) : void
		{
			
		}
	}
}