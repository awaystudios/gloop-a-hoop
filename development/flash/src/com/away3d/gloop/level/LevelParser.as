package com.away3d.gloop.level
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	
	import com.away3d.gloop.gameobjects.Hoop;
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
				if (obj != ctr) {
					if (obj.extra && obj.extra.hasOwnProperty('gah_type')) {
						switch (obj.extra['gah_type']) {
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
						
						// Non-visual object or placeholder
						if (obj.parent)
							obj.parent.removeChild(obj);
					}
					else {
						var mesh : Mesh
						
						mesh = obj as Mesh;
						if (mesh) {
							mesh.geometry.scale(_scale);
							mesh.material = new ColorMaterial(Math.random() * 0xffffff);
						}
						
						// Visual object, add if not already parented
						if (!obj.parent || obj.parent==ctr)
							level.scene.addChild(obj);
					}
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
			
			wall = new Wall(min.x*_scale, -min.y*_scale, dim.x*_scale, -dim.y*_scale);
			wall.physics.x = obj.x * _scale;
			wall.physics.y = -obj.y * _scale;
			wall.physics.rotation = -obj.rotationZ;
			
			level.add(wall);
		}
		
		
		private function parseSpawnPoint(level : Level, obj : ObjectContainer3D) : void
		{
			level.spawnPoint.x = obj.x * _scale;
			level.spawnPoint.y = -obj.y * _scale;
		}
		
		
		private function parseHoop(level : Level, obj : ObjectContainer3D) : void
		{
			var hoop : Hoop;
			
			hoop = new Hoop(obj.x * _scale, -obj.y * _scale);
			level.add(hoop);
		}
	}
}