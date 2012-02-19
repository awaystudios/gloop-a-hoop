package multitouch
{

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class MultitouchTest extends Sprite
	{
		private var _spots:Array;

		public function MultitouchTest() {
			super();
			trace( "initializing..." );
			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
		}

		private function stageInitHandler( evt:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			if( Multitouch.supportsTouchEvents ) {
				init();
			}
			else {
				trace( "no multitouch support" );
			}
		}

		private function init():void {
			trace( "init" );

			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

			stage.addEventListener( TouchEvent.TOUCH_BEGIN, handleTouchEvents );
			stage.addEventListener( TouchEvent.TOUCH_END, handleTouchEvents );

			_spots = [];
		}

		private function handleTouchEvents( event:TouchEvent ):void {
			var spot:Sprite;
			if( event.type == "touchBegin" ) {
				trace( "touchBegin called" );
				spot = getCircle();
				spot.cacheAsBitmap = true;
				spot.x = event.stageX;
				spot.y = event.stageY;
				spot.startTouchDrag( event.touchPointID, true );
				stage.addChild( spot );
				_spots[event.touchPointID] = spot;
			}
			else {
				trace( "touchEnd called" );
				spot = _spots[event.touchPointID];
				stage.removeChild( spot );
				delete _spots[event.touchPointID];
			}
		}

		private function getCircle( radius:uint = 60 ):Sprite {
			var spot:Sprite = new Sprite();
			spot.graphics.beginFill( 0xFFFFFF * Math.random() );
			spot.graphics.drawCircle( 0, 0, radius );
			return spot;
		}
	}
}