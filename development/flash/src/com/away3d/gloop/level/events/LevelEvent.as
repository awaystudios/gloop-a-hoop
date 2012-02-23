package com.away3d.gloop.level.events {
	import com.away3d.gloop.level.Level;

	import flash.events.Event;
	
	/**
	 * ...
	 */
	public class LevelEvent extends Event {
		
		public static const LEVEL_RESET:String = "levelevent_level_reset";

		private var _level:Level;
		
		public function LevelEvent(type:String, level:Level) {
			super(type, false, false);
			_level = level;
		} 
		
		public override function clone():Event { 
			return new LevelEvent(type, level);
		} 
		
		public override function toString():String { 
			return formatToString("LevelEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
		public function get level():Level {
			return _level;
		}
		
	}
	
}