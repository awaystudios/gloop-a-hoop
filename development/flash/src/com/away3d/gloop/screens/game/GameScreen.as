package com.away3d.gloop.screens.game
{

	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.lights.PointLight;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.events.GameEvent;
	import com.away3d.gloop.gameobjects.Cannon;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.hud.HUD;
	import com.away3d.gloop.input.InputManager;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.LevelProxy;
	import com.away3d.gloop.screens.ScreenBase;
	import com.away3d.gloop.screens.game.controllers.CameraController;
	import com.away3d.gloop.screens.game.controllers.LevelEditController;
	import com.away3d.gloop.utils.HierarchyTool;
	import com.away3d.gloop.utils.Timestep;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import wck.WCK;

	public class GameScreen extends ScreenBase
	{
		private var _db:LevelDatabase;
		private var _level : Level;
		private var _levelProxy:LevelProxy;
		
		private var _cameraController : CameraController;
		private var _editController : LevelEditController;

		private var _gloop:Gloop;
		private var _cannon:Cannon;

		private var _doc:WCK;
		private var _view:View3D;
		private var _inputManager:InputManager;
		
		private var _hud : HUD;
		private var _timestep:Timestep;
		

		public function GameScreen( db:LevelDatabase, view : View3D ) {
			super( false );

			_db = db;
			_view = view;
		}


		protected override function initScreen():void
		{
			initWorld();
			initHUD();
			initPersistantObjects();
			initControllers();
		}

		
		
		private function initWorld() : void
		{
			_doc = new WCK();
			_doc.x = 120;
			_doc.y = 120;
			_doc.scaleX = 0.2;
			_doc.scaleY = 0.2;
			_doc.visible = false;
			addChild( _doc );
		}
		
		
		private function initHUD() : void
		{
			_hud = new HUD(_w, _h);
			addChild(_hud);
		}
		
		
		private function initPersistantObjects() : void
		{
			_gloop = new Gloop(0, 0, this);
			_gloop.addEventListener( GameObjectEvent.GLOOP_APPROACH_GOAL_WALL, onGloopApproachGoalWall);
			_gloop.addEventListener( GameObjectEvent.GLOOP_MISSED_GOAL_WALL, onGloopMissedGoalWall);
			_gloop.addEventListener( GameObjectEvent.GLOOP_FIRED, onGloopFired );
			
			_cannon = new Cannon();
		}
		
		
		private function initControllers() : void
		{
			_inputManager = new InputManager(_view);
			_cameraController = new CameraController(_inputManager, _view.camera, _gloop);
			_editController = new LevelEditController();
		}
		
		public override function activate():void {
			super.activate();
			
			_timestep = new Timestep(60);

			_levelProxy = _db.selectedLevelProxy;
			_level = _levelProxy.level;
			
			_levelProxy.addEventListener( GameEvent.LEVEL_RESET, onLevelReset )
				
			_doc.addChild( _level.world );
			_view.scene = _level.scene;
			
			// Camera must be in scene since it needs to update
			// for the HUD to update accordingly.
			_view.scene.addChild(_view.camera);
			
			_editController.activate(_levelProxy);

			_cameraController.setBounds(
				_level.bounds.left,
				_level.bounds.right,
				_level.bounds.top,
				_level.bounds.bottom,
				0.001, 3.5); // TODO: Move these to settings
			
			_inputManager.reset(_level);
			_inputManager.activate();
			
			_cannon.physics.moveTo(_level.spawnPoint.x, _level.spawnPoint.y, false);
			_level.add(_cannon);

			_gloop.setSpawn( _level.spawnPoint.x, _level.spawnPoint.y );
			_gloop.splatComponent.splattables = _level.splattableMeshes;

			// TODO : This is a hack to not make the launcher collide with gloop on spawn (and thus remove itself). I'll fix this later /Martin
			setTimeout(function():void {
				_level.add(_gloop);
				_cannon.catchGloop(_gloop);
				_levelProxy.reset();			

				// Apply nice lighting.
				// TODO: Don't affect HUD
				/*
				for( var i:uint, len:uint = _level.scene.numChildren; i < len; ++i ) {
					HierarchyTool.recursiveApplyLightPicker( _level.scene.getChildAt( i ), _sceneLightPicker );
				}
				*/
			}, 200);
		}

		public override function deactivate():void
		{
			super.deactivate();
			_inputManager.deactivate();
			_editController.deactivate();
			
			_view.scene = new Scene3D();
		}
		
		private function onGloopApproachGoalWall(ev : GameObjectEvent) : void
		{
			_cameraController.setGloopFinishing(_level.targetRotation * Math.PI/180);
		}
		
		private function onGloopMissedGoalWall(ev : GameObjectEvent) : void
		{
			// Return to regular fired mode.
			_cameraController.setGloopMissed();
		}

		private function onGloopFired( event:GameObjectEvent ):void {
			_gloop.meshComponent.mesh.visible = true;
			_cameraController.setGloopFired(
				_view.camera.x - _gloop.physics.x,
				_view.camera.y + _gloop.physics.y);
		}

		private function onLevelReset(event : GameEvent):void
		{
			reset();
		}

		private function reset():void
		{
			_gloop.meshComponent.mesh.visible = false;
			
			_hud.reset(_levelProxy);
			
			_cannon.catchGloop(_gloop);
			
			_cameraController.setGloopIdle();
			_cameraController.resetOrientation();
			_inputManager.reset(_level);
			_inputManager.panX = _gloop.physics.x;
			_inputManager.panY = -_gloop.physics.y;
		}
		

		override protected function update():void {
			_timestep.tick();
			var updates:int = _timestep.steps;
			
			while (updates-- > 0) {
				if( _level ) _level.update();
				_cameraController.update();
			}
			
			if (_level) {
				_level.camLightX = _view.camera.x;
				_level.camLightY = _view.camera.y;
				_level.camLightZ = _view.camera.z;
			}
		}
	}
}