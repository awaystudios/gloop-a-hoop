package com.away3d.gloop.screens.game
{

	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SphereGeometry;
	
	import com.away3d.gloop.events.GameEvent;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.hud.HUD;
	import com.away3d.gloop.input.InputManager;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.LevelProxy;
	import com.away3d.gloop.screens.ScreenBase;
	import com.away3d.gloop.screens.game.controllers.CameraController;
	import com.away3d.gloop.utils.HierarchyTool;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import wck.WCK;

	public class GameScreen extends ScreenBase
	{
		private var _db:LevelDatabase;
		private var _level : Level;
		private var _levelProxy:LevelProxy;
		
		private var _cameraController : CameraController;

		private var _gloop:Gloop;

		private var _doc:WCK;
		private var _view:View3D;
		private var _cameraPointLight:PointLight;
		private var _sceneLightPicker:StaticLightPicker;
		private var _inputManager:InputManager;
		
		private var _hud : HUD;
		

		public function GameScreen( db:LevelDatabase ) {
			super( false );

			_db = db;
		}


		protected override function initScreen():void
		{
			initWorld();
			initHUD();
			initGloop();
			initControllers();
		}

		
		
		private function initWorld() : void
		{
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
		}
		
		
		private function initHUD() : void
		{
			_hud = new HUD();
			_hud.scale(0.05);
			_hud.x = -15;
			_hud.y = -5;
			_hud.z = _view.camera.lens.near + 1;
			_view.camera.addChild(_hud);
		}
		
		
		private function initGloop() : void
		{
			_gloop = new Gloop(0, 0, this);
			_gloop.addEventListener( GameObjectEvent.GLOOP_FIRED, onGloopFired );
		}
		
		
		private function initControllers() : void
		{
			_inputManager = new InputManager(_view);
			_cameraController = new CameraController(_inputManager, _view.camera, _gloop);
		}
		
		
		

		public override function activate():void {
			addEventListener( Event.ENTER_FRAME, onEnterFrame );

			_levelProxy = _db.selectedProxy;
			_level = _levelProxy.level;
			
			_levelProxy.addEventListener( GameEvent.LEVEL_RESET, onLevelReset )
				
			_doc.addChild( _level.world );
			_view.scene = _level.scene;
			
			// Camera must be in scene since it needs to update
			// for the HUD to update accordingly.
			_view.scene.addChild(_view.camera);

			_cameraController.setBounds(
				_level.dimensionsMin.x,
				_level.dimensionsMax.x,
				_level.dimensionsMin.y,
				_level.dimensionsMax.y,
				_level.dimensionsMin.z,
				_level.dimensionsMax.z);
			
			_inputManager.reset(_level);
			_inputManager.activate();

			_gloop.setSpawn( _level.spawnPoint.x, _level.spawnPoint.y );
			_gloop.splat.splattables = _level.splattableMeshes;

			_level.add(_gloop);
			_levelProxy.reset();
			
			_hud.reset(_levelProxy);

			// Apply nice lighting.
			// TODO: Don't affect HUD
			for( var i:uint, len:uint = _level.scene.numChildren; i < len; ++i ) {
				HierarchyTool.recursiveApplyLightPicker( _level.scene.getChildAt( i ), _sceneLightPicker );
			}
		}

		public override function deactivate():void
		{
			_inputManager.deactivate();
			removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}

		private function onGloopFired( event:GameObjectEvent ):void {
			_cameraController.setGloopFired(
				_view.camera.x - _gloop.physics.x,
				_view.camera.y + _gloop.physics.y);
		}

		private function onLevelReset(event : GameEvent):void
		{
			reset();
		}

		private function reset():void {
			_cameraController.setGloopIdle();
			_cameraController.resetOrientation();
			_inputManager.panX = _gloop.physics.x;
			_inputManager.panY = -_gloop.physics.y;
		}


		private function onEnterFrame( ev:Event ):void {

			if( _level )
				_level.update();

			_cameraController.update();
			
			_cameraPointLight.position = _view.camera.position;

			_view.render();
		}
	}
}