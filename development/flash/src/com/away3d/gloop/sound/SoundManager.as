package com.away3d.gloop.sound
{

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.setTimeout;

	public class SoundManager
	{
		private static var _sounds:Object;
		private static var _initialized:Boolean;
		private static var _enabled:Boolean = true;

		private static var _mainSoundChannel:SoundChannel;
		private static var _gloopSoundChannel:SoundChannel;
		private static var _fanSoundChannel:SoundChannel;

		public static const CHANNEL_MAIN:String = "mainChannel";
		public static const CHANNEL_GLOOP:String = "gloopChannel";
		public static const CHANNEL_FAN:String = "fanChannel";

		private static var _channels:Object;

		private static function init():void {
			if( !_initialized ) {
				_mainSoundChannel = new SoundChannel();
				_gloopSoundChannel = new SoundChannel();
				_fanSoundChannel = new SoundChannel();
				_channels = new Object();
				_channels[ CHANNEL_MAIN ] = _mainSoundChannel;
				_channels[ CHANNEL_GLOOP ] = _gloopSoundChannel;
				_channels[ CHANNEL_FAN ] = _fanSoundChannel;
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

		private static var _fanPlaying:Boolean;

		public static function stop( channelId:String ):void {
			if( !_channels[ channelId ] ) {
				throw new Error( "Channel id not identified in SoundManager.as: " + channelId );
			}
			trace( "stopping channel: " + channelId, _channels[ channelId ] );
// _channels[ channelId ].stop();

			if( _fanPlaying && channelId == CHANNEL_FAN ) {
				_fanSoundChannel.stop();
				trace( "fan stop" );
				_fanPlaying = false;
			}

		}

		public static function play( id:String, channelId:String = CHANNEL_GLOOP ):void {

			if( !_enabled ) return;

			var sound:Sound;
			init();
			if( !_sounds[ id ] ) {
				throw new Error( "Sound id not added to SoundManager.as: " + id );
			}
			sound = _sounds[id];

			if( !_channels[ channelId ] ) {
				throw new Error( "Channel id not identified in SoundManager.as: " + channelId );
			}

			// only has 1 voice
			if( channelId == CHANNEL_GLOOP ) {
				_gloopSoundChannel.stop();
			}

			if( _fanPlaying && channelId == CHANNEL_FAN ) {
				return;
			}

			if( channelId == CHANNEL_FAN ) {
				_fanPlaying = true;
				_fanSoundChannel = sound.play( 0, 999 );
				return;
			}

//			trace( "playing sound: " + id );
			_channels[ channelId ] = sound.play();
		}

		public static function playWithDelay( id:String, delay:Number, channelId:String = CHANNEL_GLOOP ):void {
			setTimeout( play, uint( delay * 1000 ), id, channelId );
		}

		public static function playRandom( options:Array, channelId:String = CHANNEL_GLOOP ):void {
			var index:uint = Math.floor( options.length * Math.random() );
			play( options[ index ], channelId );
		}

		public static function playRandomWithDelay( options:Array, delay:Number, channelId:String = CHANNEL_GLOOP ):void {
			var index:uint = Math.floor( options.length * Math.random() );
			playWithDelay( options[ index ], delay, channelId );
		}
	}
}