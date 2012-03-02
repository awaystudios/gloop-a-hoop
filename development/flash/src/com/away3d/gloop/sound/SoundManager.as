package com.away3d.gloop.sound
{
	import flash.media.Sound;

	public class SoundManager
	{
		private static var _sounds : Object;
		private static var _initialized : Boolean;
		
		private static function init() : void
		{
			if (!_initialized) {
				_initialized = true;
				_sounds = {};
			}
		}
		
		
		public static function addSound(id : String, sound : Sound) : void
		{
			init();
			
			_sounds[id] = sound;
		}
		
		
		public static function play(id : String) : void
		{
			var sound : Sound;
			
			init();
			
			sound = _sounds[id];
			sound.play();
		}
	}
}