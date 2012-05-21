package
{

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.media.Sound;

	public class SoundTest extends Sprite
	{
		[Embed(source="ouch.mp3")]
		private var OuchSound:Class;

		private var _sound:Sound;

		public function SoundTest() {

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var btn:Sprite = new Sprite();
			btn.x = 100;
			btn.y = 100;
			btn.graphics.beginFill( 0xFF0000, 1.0 );
			btn.graphics.drawRect( 0, 0, 100, 100 );
			btn.graphics.endFill();
			btn.addEventListener( MouseEvent.MOUSE_DOWN, btnClickHandler );
			btn.useHandCursor = btn.buttonMode = true;
			addChild( btn );

			_sound = new OuchSound() as Sound;
		}

		private function btnClickHandler( event:MouseEvent ):void {
			playSound();
		}

		private function playSound():void {

			if( !_sound ) {
				_sound = new OuchSound() as Sound;
			}

			_sound.play();
		}
	}
}
