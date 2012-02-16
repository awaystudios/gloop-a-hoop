package com.away3d.gloop.level
{
	import away3d.containers.ObjectContainer3D;
	
	import com.away3d.gloop.level.utils.SceneGraphIterator;

	public class LevelParser
	{
		public function LevelParser()
		{
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
						case 'phys':
							parsePhysics(level, obj);
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
		}
		
		
		private function parsePhysics(level : Level, obj : ObjectContainer3D) : void
		{
			
		}
		
		
		private function parseSpawnPoint(level : Level, obj : ObjectContainer3D) : void
		{
			
		}
		
		
		private function parseHoop(level : Level, obj : ObjectContainer3D) : void
		{
			
		}
	}
}