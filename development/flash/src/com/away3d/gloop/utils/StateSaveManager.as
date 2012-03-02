package com.away3d.gloop.utils
{
	import com.away3d.gloop.level.LevelDatabase;

	public class StateSaveManager
	{
		public function StateSaveManager()
		{
		}
		
		
		public function saveState(xml : XML) : void
		{
			// To be overridden
		}
		
		
		public function loadState(db : LevelDatabase) : void
		{
			// To be overridden
		}
		
		
		public function clearState() : void
		{
			// To be overridden
		}
	}
}