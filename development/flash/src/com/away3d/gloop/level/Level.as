package com.away3d.gloop.level
{
	import away3d.containers.Scene3D;
	
	import com.away3d.gloop.gameobjects.Button;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.GameObject;
	import com.away3d.gloop.gameobjects.IButtonControllable;
	
	import flash.geom.Point;
	
	import wck.World;

	public class Level
	{
		private var _scene : Scene3D;
		private var _world : World;
		
		private var _spawn_point :Point;
		private var _all_objects : Vector.<DefaultGameObject>;
		
		private var _buttons : Vector.<Button>;
		private var _btn_controllables : Vector.<IButtonControllable>;
		
		private var _mode:Boolean = EDIT_MODE;
		
		public static const EDIT_MODE:Boolean = false;
		public static const PLAY_MODE:Boolean = true;
		
		public function Level()
		{
			_scene = new Scene3D();
			_world = new World();
			_world.timeStep = 0.05;
			_world.velocityIterations = 5;
			_world.positionIterations = 5;
			_world.gravityY = 1;
			_spawn_point = new Point();
			_all_objects = new Vector.<DefaultGameObject>();
			_btn_controllables = new Vector.<IButtonControllable>();
			_buttons = new Vector.<Button>();
		}
		
		public function setMode(value:Boolean):void {
			_mode = value;
			for each(var object:DefaultGameObject in _all_objects) {
				object.setMode(value);
			}
		}
		
		public function get spawnPoint() : Point
		{
			return _spawn_point;
		}
		
		public function get scene() : Scene3D
		{
			return _scene;
		}
		
		public function get world() : World
		{
			return _world;
		}		
		
		public function get objects():Vector.<DefaultGameObject> {
			return _all_objects;
		}
		
		public function add(object:DefaultGameObject):DefaultGameObject {
			_all_objects.push(object);
			if (object.physics) world.addChild(object.physics);
			if (object.mesh) scene.addChild(object.mesh.mesh);
			
			if (object is Button) {
				_buttons.push(Button(object));
			}
			else if (object is IButtonControllable) {
				_btn_controllables.push(IButtonControllable(object));
			}
			
			return object;
		}
		
		
		public function setup() : void
		{
			var btn : Button;
			
			for each (btn in _buttons) {
				var i : uint;
				
				for (i=0; i<_btn_controllables.length; i++) {
					if (_btn_controllables[i].buttonGroup == btn.buttonGroup)
						btn.addControllable(_btn_controllables[i]);
				}
			}
		}
		
		
		public function update() : void
		{
			var i : uint;
			
			for (i=0; i<_all_objects.length; i++) {
				_all_objects[i].update(1);
			}
		}
		
		
		public function dispose() : void
		{
			var obj : DefaultGameObject;
			
			while (obj = _all_objects.pop()) {
				if (obj.mesh && obj.mesh.mesh && obj.mesh.mesh.parent)
					obj.mesh.mesh.parent.removeChild(obj.mesh.mesh);
				
				if (obj.physics && obj.physics.parent)
					obj.physics.parent.removeChild(obj.physics);
				
				obj.dispose();
			}
		}
	}
}