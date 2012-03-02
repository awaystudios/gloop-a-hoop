package com.away3d.gloop.utils
{
	import com.away3d.gloop.level.LevelDatabase;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileStateSaveManager extends StateSaveManager
	{
		private var _xmlPath : String;
		
		public function FileStateSaveManager(xmlPath : String)
		{
			super();
			
			_xmlPath = xmlPath;
		}
		
		
		public override function saveState(xml:XML):void
		{
			var file : File;
			var str : FileStream;
			
			file = File.applicationStorageDirectory.resolvePath(_xmlPath);
			
			str = new FileStream();
			str.open(file, FileMode.WRITE);
			
			str.position = 0;
			str.writeUTFBytes(xml.toXMLString());
		}
		
		
		public override function loadState(db:LevelDatabase):void
		{
			var file : File;
			
			file = File.applicationStorageDirectory.resolvePath(_xmlPath);
			if (file.exists) {
				var str : FileStream;
				var xml : XML;
			
				str = new FileStream();
				str.open(file, FileMode.READ);
				str.position = 0;
				xml = new XML(str.readUTFBytes(str.bytesAvailable));
				
				db.setStateFromXml(xml);
			}
		}
		
		
		public override function clearState():void
		{
			var file : File;
			
			file = File.applicationStorageDirectory.resolvePath(_xmlPath);
			if (file.exists) {
				file.deleteFile();
			}
		}
	}
}