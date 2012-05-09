package com.away3d.gloop.sound
{

	import flash.media.Sound;
	import flash.utils.setTimeout;

	public class SoundManager
	{
		private static var _sounds:Object;
		private static var _initialized:Boolean;
		private static var _enabled:Boolean = true;

		private static function init():void {
			if( !_initialized ) {
				_initialized = true;
				_sounds = {};
			}
		}

		public static function addSound( id:String, sound:Sound ):void {
			init();

			_sounds[id] = sound;
		}

		public static function get enabled():Boolean {
			return _enabled;
		}

		public static function set enabled( value:Boolean ):void {
			_enabled = value;
		}

		public static function play( id:String ):void {
			if( !_enabled ) return;
			var sound:Sound;
			init();
			if( !_sounds[ id ] ) {
				throw new Error( "Sound id not added to SoundManager.as: " + id );
			}
			sound = _sounds[id];
			trace( "playing sound: " + id );
			sound.play();
		}

		public static function playWithDelay( id:String, delay:Number ):void {
			setTimeout( play, uint(delay * 1000 ), id );
		}

		public static function playRandom( ...options ):void {
			var index:uint = Math.floor( options.length * Math.random() );
			play( options[ index ] );
		}
	}
}