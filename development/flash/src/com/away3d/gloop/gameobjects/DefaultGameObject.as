package com.away3d.gloop.gameobjects
{
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;

	public class DefaultGameObject extends GameObject
	{
		protected var _mesh : MeshComponent;
		protected var _physics : PhysicsComponent;
		
		public function DefaultGameObject()
		{
			super();
		}
		
		public override function update(dt:Number):void
		{
			_mesh.mesh.x = _physics.x;
			_mesh.mesh.y = _physics.y;
		}
		
		public function get physics():PhysicsComponent {
			return _physics;
		}
		
		public function get mesh():MeshComponent {
			return _mesh;
		}
	}
}