package com.away3d.gloop.screens
{

	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SphereGeometry;
	
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.hud.HUD;
	import com.away3d.gloop.input.InputManager;
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.level.events.LevelEvent;
	import com.away3d.gloop.utils.HierarchyTool;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import wck.WCK;

	public class GameScreen extends ScreenBase
	{
		private var _db:LevelDatabase;
		private var _level:Level;

		private var _gloop:Gloop;

		private var _doc:WCK;
		private var _view:View3D;
		private var _cameraPointLight:PointLight;
		private var _sceneLightPicker:StaticLightPicker;
		private var _inputManager:InputManager;
		private var _gloopIsFlying:Boolean;
		private var _fireOffset:Vector3D;
		
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
			resetCameraOrientation();
			addChild( _view );
			
			_cameraPointLight = new PointLight();
			_cameraPointLight.specular = 0.3;
			_cameraPointLight.ambient = 0.4;

			_sceneLightPicker = new StaticLightPicker( [ _cameraPointLight ] );
		}
		
		
		private function initHUD() : void
		{
			_hud = new HUD();
			_hud.scale(0.1);
			_hud.x = -15;
			_hud.y = -5;
			_hud.z = _view.camera.lens.near + 1;
			_view.camera.addChild(_hud);
		}
		
		
		private function initGloop() : void
		{
			_gloop = new Gloop(0, 0, this);
			_gloop.addEventListener( GameObjectEvent.GLOOP_FIRED, onGloopFired );
			_gloop.addEventListener( GameObjectEvent.GLOOP_HIT_GOAL_WALL, onGloopHitGoalWall );
			_gloop.addEventListener( GameObjectEvent.GLOOP_LOST_MOMENTUM, onGloopLostMomentum );
		}

		public override function activate():void {
			addEventListener( Event.ENTER_FRAME, onEnterFrame );

			_level = _db.selectedProxy.level;
			_level.addEventListener( LevelEvent.LEVEL_RESET, onLevelReset )
			_doc.addChild( _level.world );

			_view.scene = _level.scene;
			
			// Camera must be in scene since it needs to update
			// for the HUD to update accordingly.
			_view.scene.addChild(_view.camera);

			_inputManager = new InputManager( _view, _level );
			_inputManager.reset();

			_gloop.setSpawn( _level.spawnPoint.x, _level.spawnPoint.y );
			_gloop.splat.splattables = _level.splattableMeshes;

			_db.selectedProxy.level.add( _gloop );
			_db.selectedProxy.level.reset();
			
			_hud.reset(_db.selectedProxy);

			// Apply nice lighting.
			for( var i:uint, len:uint = _level.scene.numChildren; i < len; ++i ) {
				HierarchyTool.recursiveApplyLightPicker( _level.scene.getChildAt( i ), _sceneLightPicker );
			}
		}

		public override function deactivate():void {
			removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}

		private function onGloopLostMomentum( event:GameObjectEvent ):void {
			reset();
		}

		private function onGloopHitGoalWall( event:GameObjectEvent ):void {
			reset();
		}

		private function onGloopFired( event:GameObjectEvent ):void {
			_fireOffset = new Vector3D( _view.camera.x - _gloop.physics.x, _view.camera.y + _gloop.physics.y, 0 );
			_gloopIsFlying = true;
		}

		private function onLevelReset( event:LevelEvent ):void {
			reset();
		}

		private function reset():void {
			_gloopIsFlying = false;
			resetCameraOrientation();
			_inputManager.panX = _gloop.physics.x;
			_inputManager.panY = -_gloop.physics.y;
		}

		private function resetCameraOrientation():void {
			_view.camera.rotationX = 0;
			_view.camera.rotationY = 0;
			_view.camera.rotationZ = 0;
		}

		private function onEnterFrame( ev:Event ):void {

			if( _level )
				_level.update();

			var targetPosition:Vector3D = new Vector3D( 0, 0, 1 );

			// evaluate target camera position
			if( _gloopIsFlying ) {
				_fireOffset.scaleBy( 0.9 );
				targetPosition.x = _gloop.physics.x + _fireOffset.x;
				targetPosition.y = -_gloop.physics.y + _fireOffset.y;
				_view.camera.lookAt( new Vector3D( targetPosition.x, targetPosition.y, 0 ) );
			}
			else {
				_inputManager.update();
				targetPosition.x = _inputManager.panX;
				targetPosition.y = _inputManager.panY;
			}
			targetPosition.z = _inputManager.zoom;

			// contain target position
			if( targetPosition.x > _level.dimensionsMax.x ) {
				targetPosition.x = _level.dimensionsMax.x;
				_inputManager.panX = _level.dimensionsMax.x;
			} else if( targetPosition.x < _level.dimensionsMin.x ) {
				targetPosition.x = _level.dimensionsMin.x;
				_inputManager.panX = _level.dimensionsMin.x;
			}
			if( targetPosition.y > _level.dimensionsMax.y ) {
				targetPosition.y = _level.dimensionsMax.y;
				_inputManager.panY = _level.dimensionsMax.y;
			} else if( targetPosition.y < _level.dimensionsMin.y ) {
				targetPosition.y = _level.dimensionsMin.y;
				_inputManager.panY = _level.dimensionsMin.y;
			}
			if( targetPosition.z > _level.dimensionsMax.z ) {
				targetPosition.z = _level.dimensionsMax.z;
				_inputManager.zoom = _level.dimensionsMax.z;
			} else if( targetPosition.z < _level.dimensionsMin.z ) {
				targetPosition.z = _level.dimensionsMin.z;
				_inputManager.zoom = _level.dimensionsMin.z;
			}

			// ease camera towards target position
			_view.camera.x += (targetPosition.x - _view.camera.x) * 0.4;
			_view.camera.y += (targetPosition.y - _view.camera.y) * 0.4;
			_view.camera.z += ( ( targetPosition.z * 200 - 1000 ) - _view.camera.z) * 0.4;

			_cameraPointLight.position = _view.camera.position;

			_view.render();
		}
	}
}