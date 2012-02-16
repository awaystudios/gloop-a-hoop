package com.away3d.gloop.gameobjects
{
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.RigidBodyComponent;

	public class DefaultGameObject extends GameObject
	{
		protected var _mesh : MeshComponent;
		protected var _body : RigidBodyComponent;
		
		public function DefaultGameObject()
		{
			super();
		}
		
		public override function update(dt:Number):void
		{
			_mesh.mesh.x = _body.body.x;
			_mesh.mesh.y = _body.body.y;
		}
	}
}