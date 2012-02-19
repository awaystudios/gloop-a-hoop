package accelerometer
{

	import Box2DAS.Common.V2;

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.sensors.Accelerometer;

	import wck.WCK;
	import wck.World;

	public class AccelerometerTest extends WCK
	{
		private var _world:World;
		private var _accelerometer:Accelerometer;

		public function AccelerometerTest() {
			super();
			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
		}

		private function stageInitHandler( evt:Event ):void {

			removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			trace( "Accelerometer test." );

			_world = new BounceWorld( 768, 1024 );
//			_world = new BounceWorld( stage.stageWidth, stage.stageHeight );
			addChild( _world );

			_accelerometer = new Accelerometer();
			if( _accelerometer.muted ) {
				trace( "Accelerometer is not available." );
				addEventListener(Event.ENTER_FRAME, enterframeHandler);
			}
			else {
				trace( "Accelerometer is available." );
				_accelerometer.addEventListener( AccelerometerEvent.UPDATE, accelerometerUpdateHandler );
			}
		}

		private function enterframeHandler(evt:Event):void
		{
			var x:Number = ( mouseX / ( stage.stageWidth / 2 ) ) - 1;
			var y:Number = ( mouseY / ( stage.stageHeight / 2 ) ) - 1;
			updateGravity( x * 20, y * 20 );
		}

		private function accelerometerUpdateHandler( event:AccelerometerEvent ):void {
			trace( "Accelerometer update: " + event.accelerationX, event.accelerationY, event.accelerationZ );
			updateGravity( -event.accelerationX * 20, event.accelerationY * 20 );
		}

		private function updateGravity( x:Number, y:Number ):void {
			if( _world.b2world ) {
				trace( "gravity update: " + x, y );
				_world.b2world.SetGravity( new V2( x, y ) );
			}
		}
	}
}
