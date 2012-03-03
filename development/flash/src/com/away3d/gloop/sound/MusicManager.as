package com.away3d.gloop.sound
{

	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class MusicManager
	{
		private static var _themes : Object;
		private static var _initialized:Boolean;
		private static var _soundChannel:SoundChannel;
		private static var _enabled:Boolean = true;
		private static var _theme:Sound;
		private static var _currentThemeId:String;

		private static function init():void {
			if( !_initialized ) {
				_initialized = true;
				_themes = {};
			}
		}

		public static function set enabled( value:Boolean ):void {
			_enabled = value;
			stop();
			if( _enabled && _theme ) {
				_soundChannel = _theme.play();
			}
		}

		public static function get enabled():Boolean {
			return _enabled;
		}

		public static function addTheme( id:String, sound:Sound ):void {
			init();
			_themes[id] = sound;
		}

		public static function playInGameTheme():void {
			play( Themes.IN_GAME_THEME );
		}

		public static function playMainTheme():void {
			play( Themes.MAIN_THEME );
		}

		public static function stop():void {
			if( _soundChannel ) {
				_soundChannel.stop();
			}
		}

		public static function play( id:String ):void {

			if( !_enabled ) return;

			init();

			if( id == _currentThemeId ) return;

			stop();
			_theme = _themes[id];

			_soundChannel = _theme.play( 0, 9999 );
			_currentThemeId = id;
		}
	}
}
