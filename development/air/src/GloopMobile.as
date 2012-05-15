package
{
	import com.away3d.gloop.events.WrapperEvent;
	import com.away3d.gloop.sound.MusicManager;
	import com.away3d.gloop.utils.FileStateSaveManager;
	
	import flash.display.StageQuality;
	import flash.events.Event;
	
	[SWF(width="1024", heigth="768", frameRate="60")]
	public class GloopMobile extends Main
	{
		private static const STATE_XML_PATH : String = 'savedstate.xml';
		private var _wrapper:Wrapper;
		
		public function GloopMobile()
		{
			autoInit = false;
			
			_wrapper = new Wrapper();
			_wrapper.addEventListener(WrapperEvent.WRAPPER_DONE, onWrapperDone);
			addChild(_wrapper);
			
			_stateMgr = new FileStateSaveManager(STATE_XML_PATH);
			
			stage.addEventListener(Event.ACTIVATE, onStageActivate);
			stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
		}
		
		private function onWrapperDone(ev : WrapperEvent) : void
		{
			init();
		}
		
		private function onStageActivate(ev : Event) : void
		{
			MusicManager.resume();
		}
		
		
		private function onStageDeactivate(ev : Event) : void
		{
			MusicManager.pause();
		}
	}
}