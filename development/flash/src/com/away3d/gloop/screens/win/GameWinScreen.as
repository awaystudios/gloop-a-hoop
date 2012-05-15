package com.away3d.gloop.screens.win
{

	import com.away3d.gloop.screens.*;

	import com.away3d.gloop.lib.EndVideo;
	import com.away3d.gloop.lib.EndVideoBlurred;
	import com.away3d.gloop.lib.GameEndScreen;

	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class GameWinScreen extends ScreenBase
	{
		private var _container:Sprite;
		private var _normalVideo:MovieClip;
		private var _blurredVideo:MovieClip;
		private var _active:Boolean;
		private var _justActivated:Boolean;
		private var _textStuff:Sprite;
		private var _stack:ScreenStack;

		public function GameWinScreen( stack:ScreenStack ) {
			super();
			_stack = stack;
		}

		override protected function initScreen():void {

			_container = new Sprite();
			addChild( _container );

			var videoContainer:Sprite = new Sprite();
			_container.addChild( videoContainer );

			_normalVideo = new EndVideo();
			_normalVideo.stop();
			_normalVideo.visible = false;
			videoContainer.addChild( _normalVideo );

			_blurredVideo = new EndVideoBlurred();
			_blurredVideo.stop();
			_blurredVideo.visible = false;
			videoContainer.addChild( _blurredVideo );

			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );

			_textStuff = new GameEndScreen();
			_textStuff.visible = false;
			_container.addChild( _textStuff );

			var facebook:Sprite = _textStuff.getChildByName( "facebook" ) as Sprite;
			var twitter:Sprite = _textStuff.getChildByName( "twitter" ) as Sprite;
			var youtube:Sprite = _textStuff.getChildByName( "youtube" ) as Sprite;

			facebook.alpha = 0;
			twitter.alpha = 0;
			youtube.alpha = 0;

			facebook.useHandCursor = facebook.buttonMode = true;
			twitter.useHandCursor = twitter.buttonMode = true;
			youtube.useHandCursor = youtube.buttonMode = true;

			facebook.addEventListener( MouseEvent.MOUSE_UP, onFacebookMouseUp );
			twitter.addEventListener( MouseEvent.MOUSE_UP, onTwitterMouseUp );
			youtube.addEventListener( MouseEvent.MOUSE_UP, onYoutubeMouseUp );
		}

		private function onStageMouseUp( event:MouseEvent ):void {

			if( !_active ) {
				return;
			}

			if( event.target is GameEndScreen ) {
				_container.visible = false;
				_stack.gotoScreen( Screens.START );
			}
		}

		private function onYoutubeMouseUp( event:MouseEvent ):void {
			navigateToURL( new URLRequest( "http://www.youtube.com/gloopahoop" ), "_blank" );
		}

		private function onTwitterMouseUp( event:MouseEvent ):void {
			navigateToURL( new URLRequest( "http://www.twitter.com/gloopahoop" ), "_blank" );
		}

		private function onFacebookMouseUp( event:MouseEvent ):void {
			navigateToURL( new URLRequest( "http://www.facebook.com/gloopahoop" ), "_blank" );
		}

		override public function activate():void {

			_container.x = stage.stageWidth / 2;
			_container.y = stage.stageHeight / 2;

			_active = _justActivated = true;

			_normalVideo.play();
			_normalVideo.visible = true;

			super.activate();
		}

		override public function deactivate():void {

			_normalVideo.visible = false;
			_normalVideo.stop();

			_blurredVideo.visible = false;
			_blurredVideo.stop();

			_active = false;
			_textStuff.visible = false;

			super.deactivate();
		}

		override protected function update():void {

			if( !_active ) {
				return;
			}

			if( _justActivated && _normalVideo.currentFrame == 61 ) {

				_justActivated = false;

				_normalVideo.stop();
				_normalVideo.visible = false;

				_blurredVideo.play();
				_blurredVideo.visible = true;

				_textStuff.visible = true;
			}
		}
	}
}
