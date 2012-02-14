package uk.co.awamedia.gloop {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.describeType;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
		
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "error", type = "flash.events.ErrorEvent")]
	
	public class SettingsLoader extends EventDispatcher {
		
		private var _loader		:URLLoader;
		private var _xml		:XML;
		private var _targetClass:Class;
		
		public function SettingsLoader(targetClass:Class) {
			_targetClass = targetClass;
			_loader = new URLLoader(new URLRequest("settings.xml?" + Math.random()));
			_loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
		}
		
		private function handleSecurityError(e:SecurityErrorEvent):void {
			//trace("SettingsLoader", "security error loading settings", e.text);
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "security error loading settings: " + e.text));
		}
		
		private function handleIOError(e:IOErrorEvent):void {
			//trace("SettingsLoader", "io error loading settings", e.text);
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "io error loading settings: " + e.text));
		}

		private function handleLoadComplete(e:Event):void {
			try {				
				_xml = XML(_loader.data);
			} catch (e:Error) {
				//trace("SettingsLoader", "malformed xml in settings: " + e.name, e.message);
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "malformed xml in settings: " + e.name + " - " + e.message));
			}
			
			for each (var setting:XML in _xml.setting){
				_targetClass[setting.@id] = setting;
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get isComplete():Boolean {
			return _xml != null;
		}
		
		public function get xml():XML {
			return _xml;
		}
		
		public function dump():void {
			var typeXML:XML = describeType(_targetClass);
			var varlist:Array = [];
			for each (var variable:XML in typeXML.variable){
				varlist.push('<setting id="' + variable.@name + '">' + _targetClass[variable.@name] + '</setting>');
			}
			
			varlist.sort();
			
			for each (var row:String in varlist) {
				trace(row);
			}
		}
		
	}

}