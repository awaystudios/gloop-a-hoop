package
{

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.StageOrientationEvent;

	public class MobileFlipTest extends Sprite
	{
		public function MobileFlipTest() {
			super();

			// stage.scaleMode = StageScaleMode.NO_SCALE;
			// stage.align = StageAlign.TOP_LEFT;

			trace( "Orientation test started - stage: " + stage.stageWidth + ", " + stage.stageHeight );
			
			stage.addEventListener( StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange );
		}

		private function onOrientationChange( event:StageOrientationEvent ):void {
			trace( "orientation changed: " + stage.deviceOrientation );
			event.preventDefault();
		}
	}
}
