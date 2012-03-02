package
{
	import com.away3d.gloop.level.LevelDatabase;
	
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	[SWF(width="1024", heigth="768", frameRate="30")]
	public class GloopMobile extends Main
	{
		private static const STATE_XML_PATH : String = 'savedstate.xml';
		
		public function GloopMobile()
		{
			super();
		}
		
		
		protected override function saveState(xml:XML):void
		{
			var file : File;
			var str : FileStream;
			
			file = File.applicationStorageDirectory.resolvePath(STATE_XML_PATH);
			
			str = new FileStream();
			str.open(file, FileMode.WRITE);
			
			str.position = 0;
			str.writeUTFBytes(xml.toXMLString());
		}
		
		
		protected override function loadState(db:LevelDatabase):void
		{
			var file : File;
			
			file = File.applicationStorageDirectory.resolvePath(STATE_XML_PATH);
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
	}
}