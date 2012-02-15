package
{

	import away3d.primitives.SphereGeometry;

	import flash.geom.Rectangle;

	import shapes.Box;

	import wckaway.*;

	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;

	import com.li.litools.away3d.camera.OrbitCameraController;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	import shapes.ShapeBase;

	public class AwayView extends Sprite implements IWckAwayInterface
	{
		private var _view:View3D;
		private var _cameraLight:PointLight;
		private var _cameraController:OrbitCameraController;
		private var _skins:Dictionary;
		private var _bodies:Vector.<ShapeBase>;
		private var _boxMaterial:ColorMaterial;

		public function AwayView() {
			super();
			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler, false, 0, true );
		}

		// -----------------------
		// init
		// -----------------------

		private function stageInitHandler( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
			initRenderCore();
			initPhysics();
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
		}

		private function initPhysics():void {
			_bodies = new Vector.<ShapeBase>();
			_skins = new Dictionary();
		}

		private function initRenderCore():void {
			// view
			_view = new View3D();
			_view.antiAlias = 4;
			addChild( _view );
			// camera
			_view.camera.lens.far = 1000000;
			_view.camera.position = new Vector3D( 0, 300, -700 );
			//			_view.camera.lookAt( new Vector3D( 0, 500, 1000 ) );
			// camera controller
			_cameraController = new OrbitCameraController( _view.camera, stage );
			_cameraController.mouseInputFactor = 0.005;
			_cameraController.maxElevation = 0.5;
			// lights
			_cameraLight = new PointLight();
			_cameraLight.specular = 0.2;
			_cameraLight.transform = _view.camera.transform.clone();
			_view.scene.addChild( _cameraLight );
			var lights:StaticLightPicker = new StaticLightPicker( [ _cameraLight ] );
			// materials
			_boxMaterial = new ColorMaterial( 0xCCCCCC );
			_boxMaterial.lightPicker = lights;
		}

		// -----------------------
		// wck interface
		// -----------------------

		public function addBoxSkin( body:ShapeBase, bounds:Rectangle ):void {
			var cube:Mesh = new Mesh( new CubeGeometry( bounds.width, bounds.height ), _boxMaterial );
			_view.scene.addChild( cube );
			_bodies.push( body );
			_skins[ body ] = cube;
		}

		public function addCircleSkin( body:ShapeBase, bounds:Rectangle ):void {
			var sphere:Mesh = new Mesh( new SphereGeometry( bounds.width / 2 ), _boxMaterial );
			_view.scene.addChild( sphere );
			_bodies.push( body );
			_skins[ body ] = sphere;
		}

		// -----------------------
		// loop
		// -----------------------

		private function updateSkins():void {
			var body:ShapeBase;
			var skin:Mesh;
			for( var i:uint, len:uint = _bodies.length; i < len; ++i ) {
				body = _bodies[ i ];
				skin = _skins[ body ];
				skin.x = body.x;
				skin.y = -body.y;
				skin.rotationZ = -body.rotation;
			}
		}

		private function enterframeHandler( event:Event ):void {
			updateSkins();
//			_cameraController.update();
			_cameraLight.transform = _view.camera.transform.clone();
			_view.render();
		}
	}
}
