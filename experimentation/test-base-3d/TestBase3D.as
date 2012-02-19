package
{

	import agt.controllers.ControllerBase;
	import agt.controllers.camera.FreeFlyCameraController;
	import agt.input.contexts.DefaultMouseKeyboardInputContext;

	import away3d.containers.View3D;
	import away3d.lights.PointLight;
	import away3d.materials.lightpickers.StaticLightPicker;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	public class TestBase3D extends Sprite
	{
		protected var _view:View3D;
		protected var _cameraController:ControllerBase;
		protected var _cameraLight:PointLight;
		protected var _sceneLights:StaticLightPicker;

		public function TestBase3D() {
			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
		}

		private function stageInitHandler( evt:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
			initStage();
			initRenderCore();
			postInit();
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
		}

		private function initStage():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
		}

		private function initRenderCore():void {
			// view
			_view = new View3D();
			_view.antiAlias = 4;
			addChild( _view );
			// camera
			_view.camera.lens.far = 100000;
			_view.camera.position = new Vector3D( 0, 300, -700 );
			// camera controller
			_cameraController = new FreeFlyCameraController( _view.camera );
			_cameraController.inputContext = new DefaultMouseKeyboardInputContext( this, stage );
			// lights
			_cameraLight = new PointLight();
			_cameraLight.specular = 0.2;
			_cameraLight.transform = _view.camera.transform.clone();
			_view.scene.addChild( _cameraLight );
			_sceneLights = new StaticLightPicker( [ _cameraLight ] );
		}

		protected function postInit():void {
			// override
		}

		protected function preUpdate():void {
			// override
		}

		private function enterframeHandler( event:Event ):void {
			preUpdate();
			_cameraController.update();
			_cameraLight.transform = _view.camera.transform;
			_view.render();
		}
	}
}
