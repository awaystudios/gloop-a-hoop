package {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import uk.co.awamedia.gloop.Settings;
	import uk.co.awamedia.gloop.SettingsLoader;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	
	 [SWF(width = "1024", height = "768", frameRate = "60")]
	 
	public class Preloader extends MovieClip {
		
		private var _settings:SettingsLoader;
		private var _main:DisplayObject;
		private var _txt:TextField;
		
		public function Preloader(){
			_settings = new SettingsLoader(Settings);
			_settings.addEventListener(ErrorEvent.ERROR, handleSettingError);
			
			//_settings.dump();
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			addChildAt(_txt, 0);
		}
		
		private function checkFrame(e:Event):void {
			if (!_main && currentFrame == totalFrames && _settings.isComplete){
				initMain();
				go();
			}
			
			var p:Number = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
			
			_txt.text = Number(p * 100).toFixed(0) + "%";
		}
		
		private function initMain():void {
			var mainClass:Class = getDefinitionByName("Gloop2DPrototype") as Class;
			_main = new mainClass() as DisplayObject;
			addChildAt(_main, 0);
		}
		
		private function go():void {
			removeChild(_txt);
			removeEventListener(Event.ENTER_FRAME, checkFrame);
		}
		
		private function handleSettingError(e:ErrorEvent):void {
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			_txt.text = e.text;
		}
	
	}

}