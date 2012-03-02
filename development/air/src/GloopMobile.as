package
{
	import com.away3d.gloop.utils.FileStateSaveManager;
	
	[SWF(width="1024", heigth="768", frameRate="30")]
	public class GloopMobile extends Main
	{
		private static const STATE_XML_PATH : String = 'savedstate.xml';
		
		public function GloopMobile()
		{
			super();
			
			_stateMgr = new FileStateSaveManager(STATE_XML_PATH);
		}
	}
}