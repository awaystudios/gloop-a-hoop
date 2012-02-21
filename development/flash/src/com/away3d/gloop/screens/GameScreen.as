package com.away3d.gloop.screens
{

	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SphereGeometry;

	import com.away3d.gloop.camera.FreeFlyCameraController;
	import com.away3d.gloop.camera.ICameraController;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.input.InputManager;
	import com.away3d.gloop.utils.HierarchyTool;

	import flash.display.Sprite;
	import flash.events.Event;

	import wck.WCK;

	public class GameScreen extends ScreenBase
	{
		private var _db:LevelDatabase;
		private var _level:Level;

		private var _doc:WCK;
		private var _view:View3D;
		private var _cameraPointLight:PointLight;
		private var _sceneLightPicker:StaticLightPicker;
		private var _cameraController:ICameraController;
		private var _inputManager:InputManager;
		private var _mouse3dTracer:Mesh; // TODO: remove
		private var _mouse2dTracer:Sprite; // TODO: remove

		public function GameScreen( db:LevelDatabase ) {
			super();

			_db = db;
		}


		protected override function initScreen():void {
			_doc = new WCK();
			_doc.x = 80;
			_doc.y = 80;
			_doc.scaleX = 0.2;
			_doc.scaleY = 0.2;
			addChild( _doc );

			_view = new View3D();
			_view.antiAlias = 4;
			addChild( _view );

			_cameraPointLight = new PointLight();
			_cameraPointLight.specular = 0.3;
			_cameraPointLight.ambient = 0.4;

			_sceneLightPicker = new StaticLightPicker( [ _cameraPointLight ] );

			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler, false, 0, true );
		}

		private function stageInitHandler( evt:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
			_cameraController = new FreeFlyCameraController();
			_cameraController.camera = _view.camera;
			_cameraController.context = stage;
		}

		public override function activate():void {
			addEventListener( Event.ENTER_FRAME, onEnterFrame );

			_level = _db.selectedProxy.level;
			_doc.addChild( _level.world );
			_view.scene = _level.scene;
			
			_inputManager = new InputManager(_view, _level);

			_mouse3dTracer = new Mesh( new SphereGeometry( 5 ), new ColorMaterial( 0xFF0000 ) );
			_level.scene.addChild( _mouse3dTracer );

			_mouse2dTracer = new Sprite(); // TODO: remove tracer
			_mouse2dTracer.graphics.beginFill(0xFF0000);
			_mouse2dTracer.graphics.drawCircle(0, 0, 10);
			_mouse2dTracer.graphics.endFill();
			_level.world.addChild( _mouse2dTracer );

			for( var i:uint, len:uint = _level.scene.numChildren; i < len; ++i ) {
				HierarchyTool.recursiveApplyLightPicker( _level.scene.getChildAt( i ), _sceneLightPicker );
			}
		}

		public override function deactivate():void {
			removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}

		private function onEnterFrame( ev:Event ):void {
			if( _level )
				_level.update();

			_inputManager.update();

			// TODO: remove tracers
			_mouse3dTracer.x = _inputManager.mouseX;
			_mouse3dTracer.y = -_inputManager.mouseY;
			_mouse2dTracer.x = _inputManager.mouseX;
			_mouse2dTracer.y = _inputManager.mouseY;

			_cameraController.update();

			_cameraPointLight.position = _view.camera.position;

			_view.render();
		}
	}
}