package com.away3d.gloop.screens
{

	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SphereGeometry;
	
	import com.away3d.gloop.camera.FreeFlyCameraController;
	import com.away3d.gloop.camera.ICameraController;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.input.InputManager;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.utils.HierarchyTool;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import wck.WCK;

	public class GameScreen extends ScreenBase
	{
		private var _db:LevelDatabase;
		private var _level:Level;
		
		private var _gloop : Gloop;

		private var _doc:WCK;
		private var _view:View3D;
		private var _cameraPointLight:PointLight;
		private var _sceneLightPicker:StaticLightPicker;
		private var _inputManager:InputManager;
		private var _mouse3dTracer:Mesh; // TODO: remove
		private var _mouse2dTracer:Sprite; // TODO: remove

		public function GameScreen(db:LevelDatabase ) {
			super(false);

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
			_view.camera.rotationX = 20;
			addChild( _view );

			_cameraPointLight = new PointLight();
			_cameraPointLight.specular = 0.3;
			_cameraPointLight.ambient = 0.4;

			_sceneLightPicker = new StaticLightPicker( [ _cameraPointLight ] );
			
			_gloop = new Gloop(_db.selectedProxy.level.spawnPoint.x, _db.selectedProxy.level.spawnPoint.y, this);
		}

		public override function activate():void {
			addEventListener( Event.ENTER_FRAME, onEnterFrame );

			_level = _db.selectedProxy.level;
			_doc.addChild( _level.world );
			_view.scene = _level.scene;
			
			_inputManager = new InputManager(_view, _level);
			_inputManager.reset();

			/*
			_mouse3dTracer = new Mesh( new SphereGeometry( 5 ), new ColorMaterial( 0xFF0000 ) );
			_level.scene.addChild( _mouse3dTracer );

			_mouse2dTracer = new Sprite(); // TODO: remove tracer
			_mouse2dTracer.graphics.beginFill(0xFF0000);
			_mouse2dTracer.graphics.drawCircle(0, 0, 10);
			_mouse2dTracer.graphics.endFill();
			_level.world.addChild( _mouse2dTracer );
			*/
			
			_gloop.setSpawn(_level.spawnPoint.x, _level.spawnPoint.y);
			_gloop.splat.splattables = _level.splattableMeshes;
			
			_db.selectedProxy.level.add( _gloop );
			_db.selectedProxy.level.reset();
			
			// Apply nice lighting.
			for( var i:uint, len:uint = _level.scene.numChildren; i < len; ++i ) {
				HierarchyTool.recursiveApplyLightPicker( _level.scene.getChildAt( i ), _sceneLightPicker );
			}
		}

		public override function deactivate():void {
			removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}

		private function onEnterFrame( ev:Event ):void {
			var tz : Number;
			
			if( _level )
				_level.update();
			
			_inputManager.update();
			
			tz = -1000 + _inputManager.zoom * 200;
			_view.camera.z += (tz - _view.camera.z) * 0.4;
			_view.camera.x += (_inputManager.panX - _view.camera.x) * 0.4;
			_view.camera.y += (_inputManager.panY - _view.camera.y) * 0.4;
			
			// TODO: remove tracers
			/*
			_mouse3dTracer.x = _inputManager.mouseX;
			_mouse3dTracer.y = -_inputManager.mouseY;
			_mouse3dTracer.z = -_inputManager.PLANE_POSITION.z;
			_mouse2dTracer.x = _inputManager.mouseX;
			_mouse2dTracer.y = _inputManager.mouseY;
			*/

			_cameraPointLight.position = _view.camera.position;

			_view.render();
		}
	}
}