package
{

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;

	import levels.Level0;

	import utils.ShakeAndBakeConnector;

	import AwayView;
	import wckaway.WckAwayManager;

	public class WckAway3DTest extends Sprite
	{
		[Embed(source="../assets/fla/wck-away3d-test-assets.swf", mimeType="application/octet-stream")]
		private var AssetsBytes:Class;

		private var _connector:ShakeAndBakeConnector;
		private var _awayView:AwayView;
		private var _physicsView:Level0;

		private var _showingPhysics:Boolean = false;

		public function WckAway3DTest() {
			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
		}

		private function stageInitHandler( evt:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
			initStage();
			initWCK();
			initAway();
			stage.addEventListener( KeyboardEvent.KEY_DOWN, stageKeyDownHandler );
		}

		private function stageKeyDownHandler( event:KeyboardEvent ):void {
			switch( event.keyCode ) {
				case Keyboard.SPACE:
				{
					_showingPhysics = !_showingPhysics;
					_physicsView.visible = _showingPhysics;
//					_awayView.visible = !_showingPhysics;
					break;
				}
			}
		}

		private function initStage():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
		}

		// -----------------------
		// Away
		// -----------------------

		private function initAway():void {
			_awayView = new AwayView();
//			_awayView.visible = !_showingPhysics;
			WckAwayManager.instance.view = _awayView;
			addChild( _awayView );
		}

		// -----------------------
		// WCK
		// -----------------------

		private function initWCK():void {
			// load flash assets
			_connector = new ShakeAndBakeConnector( this );
			_connector.addEventListener( Event.COMPLETE, shakeAndBakeConnectionReadyHandler );
			_connector.connectData( new AssetsBytes() as ByteArray );
		}

		private function shakeAndBakeConnectionReadyHandler( event:Event ):void {
			_connector.removeEventListener( Event.COMPLETE, shakeAndBakeConnectionReadyHandler );
			_connector = null;
			// init level
			_physicsView = new Level0();
			_physicsView.visible = _showingPhysics;
			_physicsView.x = stage.stageWidth / 2;
			_physicsView.y = stage.stageHeight / 2;
			addChild( _physicsView );
		}
	}
}
