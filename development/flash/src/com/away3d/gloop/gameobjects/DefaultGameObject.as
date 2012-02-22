package com.away3d.gloop.gameobjects
{
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.level.Level;

	public class DefaultGameObject extends GameObject
	{
		private var _mode:Boolean;
		protected var _mesh : MeshComponent;
		protected var _physics : PhysicsComponent;
		
		public function DefaultGameObject()
		{
			super();
		}
		
		public override function update(dt:Number):void
		{
			if (_mesh && _physics) {
				_mesh.mesh.x = _physics.x;
				_mesh.mesh.y = -_physics.y;
				_mesh.mesh.rotationZ = -physics.rotation;
			}
		}
		
		public function setMode(value:Boolean):void {
			_mode = value;
		}
		
		public function reset():void {
			
		}
		
		public function onCollidingWithGloopStart(gloop:Gloop):void {
			
		}
		
		public function onCollidingWithGloopEnd(gloop:Gloop):void {
			
		}
		
		public function get physics():PhysicsComponent {
			return _physics;
		}
		
		public function get mesh():MeshComponent {
			return _mesh;
		}
		
		public function get debugColor1():uint {
			return 0xff0000;
		}
		
		public function get debugColor2():uint {
			return 0x00ff00;
		}
		
		public function get inEditMode():Boolean {
			return _mode == Level.EDIT_MODE;
		}
	}
}