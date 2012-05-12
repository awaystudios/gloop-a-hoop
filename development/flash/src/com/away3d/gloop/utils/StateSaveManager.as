package com.away3d.gloop.utils
{
	import com.away3d.gloop.level.LevelDatabase;

	import flash.net.SharedObject;

	public class StateSaveManager
	{
		private const GLOOP_SO_NAME:String = "gloopAHoopUserData";

		public function StateSaveManager()
		{
		}
		
		public function saveState( xml:XML ):void {
			var sharedObject:SharedObject = SharedObject.getLocal( GLOOP_SO_NAME );
			sharedObject.data.state = xml.copy();
			sharedObject.flush();
		}

		public function loadState( db:LevelDatabase ):void {
			var sharedObject:SharedObject = SharedObject.getLocal( GLOOP_SO_NAME );
			var state:XML = sharedObject.data.state;
			if( state ) {
				db.setStateFromXml( state );
			}
		}

		public function clearState():void {
			var sharedObject:SharedObject = SharedObject.getLocal( GLOOP_SO_NAME );
			sharedObject.clear();
		}
	}
}